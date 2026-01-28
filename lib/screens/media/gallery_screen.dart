import 'package:arise_and_shine/components/network_image_banner.dart';
import 'package:arise_and_shine/screens/media/download_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("gallery".tr),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('image_gallery')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading gallery"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No images found"));
          }

          // Extract images with their timestamps from Firestore documents
          List<Map<String, dynamic>> imageData = [];
          for (var doc in snapshot.data!.docs) {
            final String? imageUrl = doc['image_url'];
            final Timestamp timestamp = doc['createdAt'] ?? Timestamp.now();

            if (imageUrl != null) {
              imageData.add({
                'url': imageUrl,
                'timestamp': timestamp,
              });
            }
          }

          // Sort images by timestamp
          imageData.sort((a, b) => (b['timestamp'] as Timestamp)
              .compareTo(a['timestamp'] as Timestamp));

          // Extract sorted image URLs
          final List<String> sortedImages =
              imageData.map((data) => data['url'] as String).toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverToBoxAdapter(
                  child: NetworkImageBanner(
                    image: sortedImages.isNotEmpty ? sortedImages[0] : '',
                    press: () {},
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return NetworkImageBanner(
                        image: sortedImages[index],
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  leading: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  actions: [
                                    // IconButton(
                                    //   icon: const Icon(
                                    //     Icons.share,
                                    //   ),
                                    //   onPressed: () async {
                                    //     final url = sortedImages[index];
                                    //     await Share.share(url);
                                    //   },
                                    // ),
                                    DownloadButton(
                                        imageUrl: sortedImages[index]),
                                  ],
                                ),
                                body: PhotoViewGallery.builder(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  builder:
                                      (BuildContext context, int pageIndex) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider:
                                          NetworkImage(sortedImages[pageIndex]),
                                      initialScale:
                                          PhotoViewComputedScale.contained,
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2,
                                      heroAttributes: PhotoViewHeroAttributes(
                                          tag: sortedImages[pageIndex]),
                                    );
                                  },
                                  itemCount: sortedImages.length,
                                  loadingBuilder: (context, event) => Center(
                                    child: CircularProgressIndicator(
                                      value: event == null
                                          ? 0
                                          : event.cumulativeBytesLoaded /
                                              (event.expectedTotalBytes ?? 1),
                                      color: primaryColor,
                                    ),
                                  ),
                                  backgroundDecoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  pageController:
                                      PageController(initialPage: index),
                                  onPageChanged: (index) {
                                    // Update current index if needed
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: sortedImages.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
