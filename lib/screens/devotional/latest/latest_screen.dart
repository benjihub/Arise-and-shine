import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LatestScreen extends StatelessWidget {
  const LatestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false,
            floating: true,
            leading: const SizedBox(),
            leadingWidth: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40,
                  width: 0.7 * context.screenWidth,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "search_devotionals".tr,
                      hintText: "search_devotionals".tr,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20, child: Icon(Icons.search)),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: 70.heightBox,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
                child: Center(
                    child:
                        "no_devotionals".tr.text.color(primaryColor).make())),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 12),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, index) {
          //         return Container(
          //           padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 100,
          //                 height: 100,
          //                 decoration: const BoxDecoration(
          //                   image: DecorationImage(
          //                     image: AssetImage(
          //                         "assets/images/IMG-20241205-WA0033.jpg"),
          //                     fit: BoxFit.cover,
          //                   ),
          //                   borderRadius: BorderRadius.all(Radius.circular(8)),
          //                 ),
          //               ),
          //               const SizedBox(width: 10),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     "What is full time ministry"
          //                         .text
          //                         .bold
          //                         .black
          //                         .size(16)
          //                         .make(),
          //                     const SizedBox(height: 8),
          //                     "Proverbs 20:5 (KJV): Counsel in the heart of man is like deep water, but a man of understanding will draw it out"
          //                         .text
          //                         .maxLines(2)
          //                         .ellipsis
          //                         .make(),
          //                     const SizedBox(height: 8),
          //                     "8 Jan 25".text.size(12).make(),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //       childCount: 20,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
