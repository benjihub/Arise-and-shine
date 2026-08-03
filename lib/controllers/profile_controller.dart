import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/constants/firebase_consts.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  //text controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isloading = false.obs;
  var fullPhoneNumber = ''.obs;
  var profileImgPath = ''.obs;
  var profileImage = ''.obs;
  var isLoading = false.obs;
  var photoisUploading = false.obs;
  var isDeleting = false.obs;

  var currentLanguage = 'en'.obs;

  RxMap userDetails = {}.obs;
  var profileImageLink = '';

  final Connectivity _connectivity = Connectivity();
  Rx<bool> isConnected = false.obs;

  @override
  void onInit() {
    initConnectivity();

    getUserDetails();

    super.onInit();

    _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (results.contains(ConnectivityResult.none) || results.isEmpty) {
          isConnected.value = false;
        } else {
          isConnected.value = true;
        }
      },
    );
  }

  Future<dynamic> changeLanguage(String languageCode) async {
    try {
      Get.updateLocale(Locale(languageCode));
      savePreferredLanguage(languageCode);
      return true;
    } on Exception {
      return false;
    }
  }

  bool savePreferredLanguage(String languageCode) {
    try {
      final id = Get.find<ProfileController>().userDetails['id'];
      if (id != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({'preferred_language': languageCode});
      }
      return true;
    } on Exception {
      return false;
    }
  }

  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch for PlatformException.
    try {
      List<ConnectivityResult> results =
          await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    } on PlatformException {
      return;
    }
  }

  void timeoutChecker() {
    // Start a timer with a duration of 6 seconds
    Timer(
      const Duration(seconds: 10),
      () {
        // Check if the loading is still ongoing after 10 seconds
        if (isloading.value) {
          // If so, cancel the operation
          Get.snackbar('Sorry',
              'Operation timed out! Please check your internet connection and try again',
              snackPosition: SnackPosition.BOTTOM,
              colorText: whiteColor,
              backgroundColor: const Color.fromARGB(255, 255, 112, 112));
          isloading.value = false;
        }
      },
    );
  }

  changeImage(context) async {
    try {
      var img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<dynamic> uploadProfileImage() async {
    // Firebase Storage reference to the folder
    var folderPath = 'images/users/${currentUser!.uid}/profilePic/';

    // Get the list of all items in the folder
    final ListResult result =
        await FirebaseStorage.instance.ref(folderPath).listAll();

    // Delete any existing files in the folder
    for (var item in result.items) {
      await item.delete();
    }

    // Generate filename and destination path for the new image
    var filename = basename(profileImgPath.value);
    var destination = '$folderPath$filename';

    // Upload the new profile image
    Reference reference = FirebaseStorage.instance.ref(destination);
    await reference.putFile(File(profileImgPath.value));

    // Get and save the new profile image link
    profileImageLink = await reference.getDownloadURL();

    return true;
  }

  Future<dynamic> updateImageInFirestore({imgUrl}) async {
    var store = firestore.collection("users").doc(currentUser!.uid);
    await store.set({'profile_image_url': imgUrl}, SetOptions(merge: true));

    return true;
  }

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  changeAuthPassword({context, email, oldPassword, newPassword}) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await currentUser!.reauthenticateWithCredential(cred);

      // Reauthentication successful, update the password
      await currentUser!.updatePassword(newPassword);

      VxToast.show(context,
          msg: "Password Updated Successfully", textColor: primaryColor);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        VxToast.show(
          context,
          msg: "Current password is incorrect",
          textColor: Colors.red,
        );
      } else {
        VxToast.show(
          context,
          msg: "Error updating password: ${e.message}",
          textColor: Colors.red,
        );
      }
      return false;
    } catch (error) {
      VxToast.show(
        context,
        msg: "Error updating password: $error",
        textColor: Colors.red,
      );
      return false;
    }
  }

  Future<dynamic> fetchUserDetails() async {
    try {
      var uid = "";
      if (Get.find<ProfileController>().userDetails['id'] == null) {
        uid = Get.find<AuthController>().uid.value;
      } else {
        uid = Get.find<ProfileController>().userDetails['id'];
      }

      // Get the document from Firestore based on the uid
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      // Check if the document exists and contains the necessary fields
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        userData = userData.map((key, value) {
          if (value is Timestamp) {
            return MapEntry(key, value.toDate().toIso8601String());
          }
          return MapEntry(key, value);
        });

        if (userData.containsKey('name') && userData.containsKey('email')) {
          String jsonString = json.encode(userData);

          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Store the JSON string in SharedPreferences
          await prefs.setString('profileData', jsonString);

          return userData;
        } else {
          return false;
        }
      }

      // If the document does not exist or fields are missing, return false
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> updateUserDetails() async {
    var uid = "";
    if (Get.find<ProfileController>().userDetails['id'] == null) {
      uid = Get.find<AuthController>().uid.value;
    } else {
      uid = Get.find<ProfileController>().userDetails['id'];
    }

    try {
      // Get the document from Firestore based on the uid
      DocumentReference userDocRef = firestore.collection('users').doc(uid);

      await userDocRef.update(
        {
          'name': nameController.text,
          'email': emailController.text,
          'phone': fullPhoneNumber.value,
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

  Future<dynamic> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonProfileData = prefs.getString('profileData');

    String? jsonProfileImage = prefs.getString('profileImage');

    // Decode the JSON string back to the original data format
    if (jsonProfileData != null) {
      userDetails.value = json.decode(jsonProfileData);
    }

    String? preferredLanguage = userDetails['preferred_language'];

    if (preferredLanguage != null && preferredLanguage.isNotEmpty) {
      Get.updateLocale(Locale(preferredLanguage));
    }

    profileImage.value = jsonProfileImage ?? '';

    // print(userDetails);

    return userDetails;
  }

  Future<void> deleteUser(String userId, String email) async {
    try {
      isDeleting(true);

      // Get the current user
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.uid != userId) {
        throw Exception("User not authenticated or mismatched userId");
      }

      final providerData = currentUser.providerData;

      bool isGoogleSignIn = providerData.any(
          (userInfo) => userInfo.providerId == GoogleAuthProvider.PROVIDER_ID);

      // Reauthenticate user
      if (isGoogleSignIn) {
        // Reauthenticate with Google
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;

        if (googleAuth == null) {
          throw Exception("Failed to reauthenticate with Google");
        }

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await currentUser.reauthenticateWithCredential(credential);

        await googleSignIn.disconnect();
      } else {
        // Reauthenticate with email/password
        final AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: passwordController.text,
        );
        await currentUser.reauthenticateWithCredential(credential);
      }

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Delete the user's folder from Firebase Storage
      final userFolderRef =
          FirebaseStorage.instance.ref().child('images/users/$userId');
      final ListResult folderContents = await userFolderRef.listAll();

      for (Reference fileRef in folderContents.items) {
        await fileRef.delete();
      }

      for (Reference dirRef in folderContents.prefixes) {
        final ListResult subDirContents = await dirRef.listAll();
        for (Reference subFileRef in subDirContents.items) {
          await subFileRef.delete();
        }
      }

      // Delete the user from Firebase Authentication
      await currentUser.delete();
    } catch (e) {
      rethrow;
    } finally {
      isDeleting(false);
    }
  }
}
