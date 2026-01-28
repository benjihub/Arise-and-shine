import 'package:arise_and_shine/components/custom_tabs.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:arise_and_shine/components/audios_screen.dart';
import 'package:arise_and_shine/components/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestmoniesScreen extends StatefulWidget {
  const TestmoniesScreen({super.key});

  @override
  State<TestmoniesScreen> createState() => _TestmoniesScreenState();
}

class _TestmoniesScreenState extends State<TestmoniesScreen>
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
      appBar: AppBar(
        title: Text("testimonies".tr),
        centerTitle: true,
      ),
      body: Column(
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
                VideosScreen(videos: sermonsController.videoTestimonies),
                AudiosScreen(audios: sermonsController.audioTestimonies),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
