import 'package:arise_and_shine/components/network_image_banner.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/media/download_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

          // Extract image URLs from Firestore documents (already sorted by query)
          final List<String> imageUrls = snapshot.data!.docs
              .map((doc) => doc['image_url'] as String?)
              .whereType<String>()
              .toList();

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverToBoxAdapter(
                  child: NetworkImageBanner(
                    image: imageUrls.isNotEmpty ? imageUrls[0] : '',
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
                        image: imageUrls[index],
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
                                    //     final url = imageUrls[index];
                                    //     await Share.share(url);
                                    //   },
                                    // ),
                                    DownloadButton(
                                        imageUrl: imageUrls[index]),
                                  ],
                                ),
                                body: PhotoViewGallery.builder(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  builder:
                                      (BuildContext context, int pageIndex) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider:
                                          NetworkImage(imageUrls[pageIndex]),
                                      initialScale:
                                          PhotoViewComputedScale.contained,
                                      minScale:
                                          PhotoViewComputedScale.contained,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2,
                                      heroAttributes: PhotoViewHeroAttributes(
                                          tag: imageUrls[pageIndex]),
                                    );
                                  },
                                  itemCount: imageUrls.length,
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
                    childCount: imageUrls.length,
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
