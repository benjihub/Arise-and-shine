import 'dart:async';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/constants/firebase_consts.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/entry_point.dart';
import 'package:arise_and_shine/screens/onbording/verification_auth_screen.dart';
import 'package:arise_and_shine/screens/profile/update_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var signupemailController = TextEditingController();
  var signuppasswordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();

  var uid = ''.obs;
  var isloading = false.obs;
  var isSocialloading = false.obs;

  // For storing the verification ID
  var verificationId = ''.obs;

  var isRequestingOTPLoading = false.obs;
  var isVerifyingOTPLoading = false.obs;

  var isNumberValid = false.obs;

  var isResendOtp = false.obs;

  var isPhoneSignin = false.obs;

  var resendTimeout = 60.obs;

  RxBool isGuest = false.obs;

  Timer? _resendTimer;

  var currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    isGuestUser();
  }

  var profileController = Get.put(ProfileController());

  Future<void> signInWithPhone(String phoneNumber) async {
    UserCredential? userCredential;

    try {
      isRequestingOTPLoading(true);

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            userCredential = await auth.signInWithCredential(credential);
            final user = userCredential?.user;
            if (user == null) {
              throw FirebaseAuthException(code: 'null-user');
            }
            uid.value = user.uid;
            await firestore.collection('users').doc(uid.value).set({
              'id': uid.value,
              'phone': phoneController.text,
            }, SetOptions(merge: true));

            final fetched = await profileController.fetchUserDetails();
            if (fetched != false &&
                await profileController.getUserDetails() != null) {
              Get.offAll(() => const EntryPoint());
            } else {
              Get.to(() => const UpdateProfileScreen());
            }
            Get.snackbar('Success', 'Phone number automatically verified',
                colorText: whiteColor, backgroundColor: primaryColor);
          } catch (error, stackTrace) {
            _logAuthFailure('Automatic phone sign-in', error, stackTrace);
            _showAuthError('Phone sign-in could not be completed.');
          } finally {
            isRequestingOTPLoading(false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          isRequestingOTPLoading(false);

          Get.snackbar('Error', e.message ?? 'Phone number verification failed',
              colorText: whiteColor, backgroundColor: errorColor);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;

          isRequestingOTPLoading(false);

          startResendTimer(); // Start the timer when the code is sent
          Get.snackbar('Code Sent', 'Verification code sent to $phoneNumber',
              colorText: whiteColor, backgroundColor: primaryColor);

          if (isResendOtp.value) {
            Get.back();
            Get.to(
              () => const VerificationAuthPage(),
            );
            isResendOtp(false);
          } else {
            Get.to(
              () => const VerificationAuthPage(),
            );
            isResendOtp(false);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
    } catch (e) {
      isRequestingOTPLoading(false);
      Get.snackbar('Error', 'Failed to send OTP',
          colorText: whiteColor, backgroundColor: errorColor);
    }
  }

  Future<dynamic> verifyOTP(String smsCode) async {
    UserCredential? userCredential;

    try {
      isVerifyingOTPLoading(true);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      userCredential = await auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'null-user');
      }
      uid.value = user.uid;

      await firestore.collection('users').doc(uid.value).set({
        'id': uid.value,
        'phone': phoneController.text,
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Phone number successfully verified',
          colorText: whiteColor, backgroundColor: primaryColor);
      isVerifyingOTPLoading(false);
      return true;
    } catch (e) {
      isVerifyingOTPLoading(false);

      Get.snackbar('Error', '$e',
          colorText: whiteColor, backgroundColor: errorColor);
      return false;
    }
  }

  void startResendTimer() {
    resendTimeout.value = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimeout.value > 0) {
        resendTimeout.value--;
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  // Handle resending the code
  void resendCode(String phoneNumber) {
    if (resendTimeout.value == 0) {
      isResendOtp(true);

      signInWithPhone(phoneNumber);
    } else {
      Get.snackbar('Wait',
          'You can resend the code after ${resendTimeout.value} seconds.',
          colorText: whiteColor, backgroundColor: primaryColor);
    }
  }

  // Save guest status to SharedPreferences
  Future<void> setGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', true);
    isGuest.value = true;
  }

  // Check guest status and return a boolean
  Future<bool> isGuestUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isGuest.value = prefs.getBool('isGuest') ?? false;
    return isGuest.value;
  }

  // Clear guest status (e.g., when user logs in)
  Future<void> clearGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isGuest');
    isGuest.value = false;
  }

  clearAuthData() {
    emailController.clear();
    passwordController.clear();
    signupemailController.clear();
    signuppasswordController.clear();
    phoneController.clear();
    nameController.clear();
  }

  /// Uses FirebaseAuth's native Apple provider. It creates and validates the
  /// nonce internally, avoiding the unsafe hand-built Apple credential flow
  /// that was previously commented out here.
  Future<UserCredential?> appleSignIn() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      _showAuthError('Sign in with Apple is available on iPhone.');
      return null;
    }

    try {
      isSocialloading(true);
      debugPrint('Starting Apple sign-in.');
      final provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      final userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);
      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Apple did not return a user account.',
        );
      }

      await _saveUserDetailsToFirestore(user);
      uid.value = user.uid;
      debugPrint('Apple sign-in completed for uid=${user.uid}.');
      return userCredential;
    } on FirebaseAuthException catch (error, stackTrace) {
      _logAuthFailure('Apple sign-in', error, stackTrace);
      _showAuthError(_messageForAuthError(error));
      isSocialloading(false);
      return null;
    } catch (error, stackTrace) {
      _logAuthFailure('Apple sign-in', error, stackTrace);
      _showAuthError('Apple sign-in could not be completed. Please try again.');
      isSocialloading(false);
      return null;
    }
  }

  Future<void> _saveUserDetailsToFirestore(
    User user, {
    String? appleEmail,
    String? appleName,
  }) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();

      if (!snapshot.exists) {
        await userDoc.set({
          'id': user.uid,
          'email': appleEmail ?? user.email,
          'phone': '',
          'name': appleName ?? user.displayName,
          'profile_image_url': user.photoURL ?? "",
          'preferred_language': currentLanguage.value,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userDoc.update({
          'profile_image_url': user.photoURL ?? "",
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user details: $e');
      }
    }
  }

  // Google SignIn
  Future<UserCredential?> googleSignIn() async {
    try {
      isSocialloading(true);
      debugPrint('Starting Google sign-in.');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Cancellation is an expected outcome, not an error and never uses !.
        debugPrint('Google sign-in cancelled by user.');
        isSocialloading(false);
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-google-id-token',
          message: 'Google did not return an ID token.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'null-user',
          message: 'Firebase did not return a user account.',
        );
      }

      // Save user details to Firestore
      await _saveUserDetailsToFirestore(user);

      uid.value = user.uid;
      debugPrint('Google sign-in completed for uid=${user.uid}.');

      return userCredential;
    } on FirebaseAuthException catch (error, stackTrace) {
      _logAuthFailure('Google sign-in', error, stackTrace);
      _showAuthError(_messageForAuthError(error));
      isSocialloading(false);
      return null;
    } catch (error, stackTrace) {
      _logAuthFailure('Google sign-in', error, stackTrace);
      _showAuthError('Google sign-in could not be completed. Please try again.');
      isSocialloading(false);
      return null;
    }
  }

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    final email = emailController.text.trim();
    final password = passwordController.text;
    try {
      debugPrint('Starting email sign-in for $email.');
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'null-user');
      }
      uid.value = user.uid;
      debugPrint('Email sign-in completed for uid=${user.uid}.');
    } on FirebaseAuthException catch (e) {
      _logAuthFailure('Email sign-in', e, StackTrace.current);
      VxToast.show(context, msg: _messageForAuthError(e));
    } catch (error, stackTrace) {
      _logAuthFailure('Email sign-in', error, stackTrace);
      VxToast.show(context, msg: 'Unable to sign in. Please try again.');
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: signupemailController.text.trim(),
          password: signuppasswordController.text);

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'null-user');
      }
      uid.value = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid.value).set({
        'id': uid.value,
        'email': signupemailController.text.trim(),
        'name': nameController.text,
        'preferred_language': currentLanguage.value,
        'phone': phoneController.text,
        'profile_image_url': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      _logAuthFailure('Email sign-up', e, StackTrace.current);
      VxToast.show(context, msg: _messageForAuthError(e));
    } catch (error, stackTrace) {
      _logAuthFailure('Email sign-up', error, stackTrace);
      VxToast.show(context,
          msg: 'Unable to create the account. Please try again.');
    }

    return userCredential;
  }

  Future<void> logoutMethod(context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void _showAuthError(String message) {
    Get.snackbar(
      'Sign-in failed',
      message,
      colorText: whiteColor,
      backgroundColor: errorColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _messageForAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'The email address or password is incorrect.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'account-exists-with-different-credential':
        return 'This email is already linked to a different sign-in method.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  void _logAuthFailure(String operation, Object error, StackTrace stackTrace) {
    // Never log passwords, tokens, authorization codes, or full credentials.
    debugPrint('$operation failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  Future<void> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "A password reset link has been sent to $email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "invalid-email":
            errorMessage = "The email address is not valid.";
            break;
          case "user-not-found":
            errorMessage = "No user found with this email address.";
            break;
          default:
            errorMessage = "An error occurred. Please try again.";
        }
      } else {
        errorMessage = "An unexpected error occurred.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<dynamic> updateUserDetailsForthefirsttime() async {
    try {
      // Get the document from Firestore based on the uid
      DocumentReference userDocRef =
          firestore.collection('users').doc(uid.value);

      await userDocRef.update(
        {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'preferred_language': currentLanguage.value,
          'profile_image_url': '',
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      // Return true if the update is successful
      return true;
      // If the document does not exist or fields are missing, return false
    } catch (e) {
      // Return false if there is an error

      return false;
    }
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }
}
