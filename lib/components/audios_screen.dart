import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/components/audio_player.dart';
import 'package:arise_and_shine/widgets/search_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AudiosScreen extends StatefulWidget {
  final List<dynamic> audios;
  const AudiosScreen({super.key, required this.audios});

  @override
  State<AudiosScreen> createState() => _AudiosScreenState();
}

class _AudiosScreenState extends State<AudiosScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> filteredAudios;

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all videos
    filteredAudios = widget.audios;

    // Listen for search text changes
    _searchController.addListener(() {
      setState(() {
        filteredAudios = widget.audios
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
                "search_audios".tr,
                "search_audios".tr,
              ),
            ),
            SliverToBoxAdapter(
              child: 20.heightBox,
            ),
            filteredAudios.isEmpty
                ? SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                        child: Center(
                            child: "no_audio_sermons"
                                .tr
                                .text
                                .color(primaryColor)
                                .make())),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          String formattedDate = '';

                          if (filteredAudios[index]['publishedAt']
                              is Timestamp) {
                            DateTime date = (filteredAudios[index]
                                    ['publishedAt'] as Timestamp)
                                .toDate();
                            formattedDate =
                                DateFormat('MMMM d, yyyy').format(date);
                          } else if (filteredAudios[index]['publishedAt']
                              is String) {
                            DateTime date = DateTime.parse(
                                filteredAudios[index]['publishedAt']);
                            formattedDate =
                                DateFormat('MMMM d, yyyy').format(date);
                          }

                          return Container(
                            padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: NetworkImageWithLoader(filteredAudios[
                                          index]['thumbnail'] ??
                                      "https://firebasestorage.googleapis.com/v0/b/arise-and-shine-tanzania.firebasestorage.app/o/IMG-20241205-WA0020.jpg?alt=media&token=fa8c38c8-574d-4ef5-b4e2-0865100c74d0"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      filteredAudios[index]['title']
                                          .toString()
                                          .text
                                          .bold
                                          .black
                                          .maxLines(1)
                                          .ellipsis
                                          .size(16)
                                          .make(),
                                      const SizedBox(height: 8),
                                      filteredAudios[index]['description']
                                          .toString()
                                          .text
                                          .maxLines(2)
                                          .ellipsis
                                          .size(12)
                                          .color(Colors.grey)
                                          .make(),
                                      const SizedBox(height: 8),
                                      formattedDate.text
                                          .size(12)
                                          .color(Colors.grey)
                                          .make(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).box.transparent.make().onTap(
                                () => Get.to(
                                  () => AudioPlayerScreen(
                                    audioUrl: filteredAudios[index]['link'],
                                  ),
                                  transition: Transition.fadeIn,
                                ),
                              );
                        },
                        childCount: filteredAudios.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
