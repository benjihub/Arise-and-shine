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
          isRequestingOTPLoading(false);

          userCredential = await auth.signInWithCredential(credential);

          Get.snackbar('Success', 'Phone number automatically verified',
              colorText: whiteColor, backgroundColor: primaryColor);

          uid.value = userCredential!.user!.uid;

          await firestore.collection('users').doc(uid.value).set({
            'id': uid.value,
            'phone': phoneController.text,
          }, SetOptions(merge: true));

          profileController.fetchUserDetails().then(
            (value) {
              if (value != false) {
                profileController.getUserDetails().then(
                  (value) {
                    if (value != null) {
                      Get.offAll(
                        () => const EntryPoint(),
                      );
                    }
                  },
                );
              } else {
                Get.to(
                  () => const UpdateProfileScreen(),
                );
              }
            },
          );
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

      uid.value = userCredential.user!.uid;

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

  // Apple SignIn
  // Future<dynamic> appleSignIn() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     isSocialloading(true);

  //     // Create full name from given and family name
  //     final fullName = [credential.givenName, credential.familyName]
  //         .where((name) => name != null)
  //         .join(' ');

  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );

  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //     final User user = userCredential.user!;

  //     // Save user details including Apple-specific information
  //     await _saveUserDetailsToFirestore(
  //       user,
  //       appleUserIdentifier: credential.userIdentifier,
  //       appleEmail: credential.email,
  //       appleName: fullName.isNotEmpty ? fullName : user.displayName,
  //     );

  //     uid.value = userCredential.user!.uid;

  //     return true;
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print('Apple Sign-In Error: $error');
  //     }
  //     return false;
  //   }
  // }

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
  Future<dynamic> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      isSocialloading(true);

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user!;

      // Save user details to Firestore
      await _saveUserDetailsToFirestore(user);

      uid.value = userCredential.user!.uid;

      return true;
    } catch (error) {
      // print('Google Sign-In Error: $error');
      return false;
    }
  }

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);

      uid.value = userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: signupemailController.text,
          password: signuppasswordController.text);

      // Get the user ID
      uid.value = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid.value).set({
        'id': uid.value,
        'email': signupemailController.text,
        'name': nameController.text,
        'preferred_language': currentLanguage.value,
        'phone': phoneController.text,
        'profile_image_url': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
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
