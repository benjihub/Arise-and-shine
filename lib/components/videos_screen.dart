import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/components/video_sermon_details.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:arise_and_shine/widgets/search_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VideosScreen extends StatefulWidget {
  final List<dynamic> videos;
  const VideosScreen({super.key, required this.videos});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> filteredVideos;
  var sermonsController = Get.put(SermonsController());

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all videos
    filteredVideos = widget.videos;

    // Listen for search text changes
    _searchController.addListener(() {
      setState(() {
        filteredVideos = widget.videos
            .where((video) => video['title']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              pinned: false,
              floating: true,
              leading: const SizedBox(),
              leadingWidth: 0,
              title: searchField(
                context,
                _searchController,
                "search_videos".tr,
                "search_videos".tr,
              ),
            ),
            filteredVideos.isEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                        child: Center(
                            child: "no_video_sermons"
                                .tr
                                .text
                                .color(primaryColor)
                                .make())),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        String formattedDate = '';

                        if (filteredVideos[index]['publishedAt'] is Timestamp) {
                          DateTime date = (filteredVideos[index]['publishedAt']
                                  as Timestamp)
                              .toDate();
                          formattedDate =
                              DateFormat('MMMM d, yyyy').format(date);
                        } else if (filteredVideos[index]['publishedAt']
                            is String) {
                          DateTime date = DateTime.parse(
                              filteredVideos[index]['publishedAt']);
                          formattedDate =
                              DateFormat('MMMM d, yyyy').format(date);
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .bottomNavigationBarTheme
                                .backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 100,
                                child: NetworkImageWithLoader(
                                  filteredVideos[index]['thumbnail'] ??
                                      "https://firebasestorage.googleapis.com/v0/b/arise-and-shine-tanzania.firebasestorage.app/o/IMG-20241205-WA0020.jpg?alt=media&token=fa8c38c8-574d-4ef5-b4e2-0865100c74d0",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    filteredVideos[index]['title']
                                        .toString()
                                        .text
                                        .bold
                                        .maxLines(1)
                                        .ellipsis
                                        .size(13)
                                        .make(),
                                    const SizedBox(height: 8),
                                    filteredVideos[index]['description']
                                        .toString()
                                        .text
                                        .maxLines(2)
                                        .ellipsis
                                        .size(12)
                                        .color(Colors.grey)
                                        .make(),
                                    const SizedBox(height: 8),
                                    formattedDate
                                        .toString()
                                        .text
                                        .size(12)
                                        .color(Colors.grey)
                                        .make(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).box.p3.transparent.make().onTap(() {
                          Get.to(
                            () => VideoSermonDetails(
                              videoData: filteredVideos[index],
                              videos: filteredVideos,
                            ),
                            transition: Transition.fadeIn,
                          );
                        });
                      }, childCount: filteredVideos.length),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
