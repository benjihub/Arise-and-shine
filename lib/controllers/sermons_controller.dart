import 'package:arise_and_shine/constants/firebase_consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SermonsController extends GetxController {
  RxList videoSermons = [].obs;
  RxList audioSermons = [].obs;
  RxList videoTestimonies = [].obs;
  RxList audioTestimonies = [].obs;
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> news = [];
  List<Map<String, dynamic>> devotionals = [];
  var isLoading = false.obs;
  var isLoadingNextPage = false.obs;

  @override
  void onInit() {
    fetchAudioSermons();
    fetchVideoSermons();
    fetchVideoTestimonies();
    fetchAudioTestimonies();
    super.onInit();
  }

  fetchVideoSermons() async {
    try {
      isLoading(true);

      QuerySnapshot querySnapshot = await firestore
          .collection('video_sermons')
          .orderBy('publishedAt', descending: true)
          .get();

      // Map the query results to a list of video sermons
      videoSermons.value = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      isLoading(false);

      return videoSermons;
    } catch (e) {
      isLoading(false);

      return [];
    }
  }

  fetchAudioSermons() async {
    try {
      isLoading(true);

      QuerySnapshot querySnapshot = await firestore
          .collection('audio_sermons')
          .orderBy('publishedAt', descending: true)
          .get();

      // Map the query results to a list of video sermons
      audioSermons.value = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      isLoading(false);

      return audioSermons;
    } catch (e) {
      isLoading(false);

      return [];
    }
  }

  fetchVideoTestimonies() async {
    try {
      isLoading(true);

      QuerySnapshot querySnapshot = await firestore
          .collection('video_testimonies')
          .orderBy('publishedAt', descending: true)
          .get();

      // Map the query results to a list of video sermons
      videoTestimonies.value = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      isLoading(false);

      return videoTestimonies;
    } catch (e) {
      isLoading(false);

      return [];
    }
  }

  fetchAudioTestimonies() async {
    try {
      isLoading(true);

      QuerySnapshot querySnapshot = await firestore
          .collection('audio_testimonies')
          .orderBy('publishedAt', descending: true)
          .get();

      // Map the query results to a list of video sermons
      audioTestimonies.value = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      isLoading(false);

      return audioTestimonies;
    } catch (e) {
      isLoading(false);

      return [];
    }
  }
}
