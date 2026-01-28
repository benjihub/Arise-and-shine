import 'package:arise_and_shine/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinistryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  TextEditingController prayerRequest1Controller = TextEditingController();
  TextEditingController prayerRequest2Controller = TextEditingController();
  TextEditingController prayerRequest4Controller = TextEditingController();
  TextEditingController prayerRequest3Controller = TextEditingController();
  TextEditingController prayerRequest5Controller = TextEditingController();
  TextEditingController prayerRequest6Controller = TextEditingController();
  TextEditingController prayerRequest7Controller = TextEditingController();
  TextEditingController prayerRequest8Controller = TextEditingController();
  TextEditingController prayerRequest9Controller = TextEditingController();
  TextEditingController prayerRequest10Controller = TextEditingController();
  TextEditingController prayerRequest11Controller = TextEditingController();
  TextEditingController prayerRequest12Controller = TextEditingController();

  var isloading = false.obs;

  RxList imageUrls = [].obs;

  RxMap socialsList = {}.obs;

  RxMap settings = {}.obs;

  RxList radiosList = [].obs;

  RxString tvLink = "".obs;

  RxList events = [].obs;

  @override
  void onInit() {
    fetchSliderImages();
    fetchTvLink();
    fetchRadios();
    fetchsocialsList();
    fetchSettings();
    fetchEvents();
    super.onInit();
  }

  Future<void> fetchSettings() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('settings').get();

      // Convert the documents into a map

      for (var doc in snapshot.docs) {
        settings[doc.id] = doc.data();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching settings: $e");
      }
    }
  }

  Future<void> fetchSliderImages() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('slider_images').get();
      final urls =
          snapshot.docs.map((doc) => doc['imageUrl'] as String).toList();

      imageUrls.value = urls;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching images: $e");
      }
    }
  }

  Future<void> fetchRadios() async {
    try {
      isloading(true);

      final snapshot =
          await FirebaseFirestore.instance.collection('radios').get();

      final sortedRadios = snapshot.docs.map((doc) => doc.data()).toList()
        ..sort((a, b) {
          final nameA = (a['name'] ?? '').toLowerCase();
          final nameB = (b['name'] ?? '').toLowerCase();
          return nameA.compareTo(nameB);
        });

      radiosList.value = sortedRadios;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching radios: $e");
      }
    } finally {
      isloading(false);
    }
  }

  Future<void> fetchsocialsList() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('socials')
          .doc('C10h4p0BJ3asNQSgUyAb')
          .get();

      socialsList.value = snapshot.data()!;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching socials: $e");
      }
    }
  }

  Future<String?> fetchTvLink() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('settings')
              .doc('tv_link')
              .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();

        tvLink.value = data?['link'];

        return tvLink.value;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching TV link: $e');
      }
      return null;
    }
  }

  Future<void> submitJoinMinistryForm({
    required String name,
    required String email,
    required String contact,
    required String location,
    String? comment,
  }) async {
    try {
      isloading(true);
      Map<String, dynamic> formData = {
        'name': name,
        'email': email,
        'contact': contact,
        'location': location,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('ministry_join_requests').add(formData);

      isloading(false);

      clearFields();

      Get.snackbar(
        'Success',
        'Your form has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      isloading(false);

      Get.snackbar(
        'Error',
        'Failed to submit the form. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitPrayerRequestForm({
    required String name,
    required String contact,
    required String location,
    required List<String> prayerRequest,
  }) async {
    try {
      isloading(true);
      Map<String, dynamic> formData = {
        'name': name,
        'contact': contact,
        'location': location,
        'prayer_request': prayerRequest,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('prayer_requests').add(formData);

      isloading(false);

      clearFields();

      Get.snackbar(
        'Success',
        'Your request has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      isloading(false);

      Get.snackbar(
        'Error',
        'Failed to submit request. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitCommitToChirstForm({
    required String name,
    required String email,
    required String contact,
    required String location,
    String? comment,
  }) async {
    try {
      isloading(true);
      Map<String, dynamic> formData = {
        'name': name,
        'email': email,
        'contact': contact,
        'location': location,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('ministry_join_requests').add(formData);

      isloading(false);

      clearFields();

      Get.snackbar(
        'Congratulations..',
        'Your decision has been submitted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      isloading(false);

      Get.snackbar(
        'Error',
        'Failed to submit the form. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitMessageToContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      isloading(true);
      // Add data to Firestore collection
      await _firestore.collection('contact_messages').add({
        'name': name,
        'email': email,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      clearFields();

      nameController.clear();
      emailController.clear();

      Get.snackbar(
        'Success',
        'Your message has been sent successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryColor,
        colorText: whiteColor,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send your message. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: errorColor,
        colorText: whiteColor,
      );
    } finally {
      isloading(false);
    }
  }

  Future<void> fetchEvents() async {
    try {
      isloading(true);

      final snapshot =
          await FirebaseFirestore.instance.collection('events').get();

      final sortedEvents = snapshot.docs.map((doc) => doc.data()).toList()
        ..sort((a, b) {
          final dateA = a['date'] as String?;
          final dateB = b['date'] as String?;

          if (dateA == null || dateB == null) {
            return 0;
          }

          // Parse the date strings into DateTime objects
          final dateTimeA = DateTime.parse(dateA);
          final dateTimeB = DateTime.parse(dateB);

          // Sort in descending order (newest first)
          return dateTimeB.compareTo(dateTimeA);
        });

      events.value = sortedEvents;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching events: $e");
      }
    } finally {
      isloading(false);
    }
  }

  clearFields() {
    contactController.clear();
    locationController.clear();
    commentController.clear();

    prayerRequest1Controller.clear();
    prayerRequest2Controller.clear();
    prayerRequest4Controller.clear();
    prayerRequest3Controller.clear();
    prayerRequest5Controller.clear();
    prayerRequest6Controller.clear();
    prayerRequest7Controller.clear();
    prayerRequest8Controller.clear();
    prayerRequest9Controller.clear();
    prayerRequest10Controller.clear();
    prayerRequest11Controller.clear();
    prayerRequest12Controller.clear();
  }
}
