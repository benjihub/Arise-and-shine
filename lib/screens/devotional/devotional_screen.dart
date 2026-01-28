import 'package:arise_and_shine/components/custom_tabs.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/screens/devotional/latest/latest_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalScreen extends StatefulWidget {
  const DevotionalScreen({super.key});

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: "devotionals".tr.text.make(),
        centerTitle: true,
      ),
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
                  buildAnimatedTab("latest".tr, 0, _tabController, context),
                  buildAnimatedTab("favorite".tr, 1, _tabController, context),
                ],
              ),
            ),
          ),
          5.heightBox,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LatestScreen(),
                // Favorite(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
