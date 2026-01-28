import 'package:arise_and_shine/components/custom_tabs.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:arise_and_shine/components/audios_screen.dart';
import 'package:arise_and_shine/components/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SermonsScreen extends StatefulWidget {
  final bool isAppBarVisible;
  const SermonsScreen({super.key, required this.isAppBarVisible});

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var sermonsController = Get.find<SermonsController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppBarVisible
          ? AppBar(
              title: Text(
                "sermons".tr,
              ),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: goldenColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAnimatedTab("videos".tr, 0, _tabController, context),
                  buildAnimatedTab("audios".tr, 1, _tabController, context),
                ],
              ),
            ),
          ),
          5.heightBox,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                VideosScreen(videos: sermonsController.videoSermons),
                AudiosScreen(audios: sermonsController.audioSermons),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
