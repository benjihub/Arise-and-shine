import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/components/video_sermon_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VideoList extends StatelessWidget {
  final List<dynamic> videos;
  const VideoList(
      {super.key, required videoTitleToEliminate, required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  String formattedDate = '';

                  if (videos[index]['publishedAt'] is Timestamp) {
                    DateTime date =
                        (videos[index]['publishedAt'] as Timestamp).toDate();
                    formattedDate = DateFormat('MMMM d, yyyy').format(date);
                  } else if (videos[index]['publishedAt'] is String) {
                    DateTime date =
                        DateTime.parse(videos[index]['publishedAt']);
                    formattedDate = DateFormat('MMMM d, yyyy').format(date);
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 100,
                          child: NetworkImageWithLoader(
                            videos[index]['thumbnail'] ??
                                "https://firebasestorage.googleapis.com/v0/b/arise-and-shine-tanzania.firebasestorage.app/o/IMG-20241205-WA0020.jpg?alt=media&token=fa8c38c8-574d-4ef5-b4e2-0865100c74d0",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              videos[index]['title']
                                  .toString()
                                  .text
                                  .bold
                                  .maxLines(1)
                                  .ellipsis
                                  .size(13)
                                  .make(),
                              const SizedBox(height: 8),
                              videos[index]['description']
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
                    Get.back();
                    Get.to(
                      () => VideoSermonDetails(
                        videoData: videos[index],
                        videos: videos,
                      ),
                      transition: Transition.fadeIn,
                    );
                  });
                },
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
