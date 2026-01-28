import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/components/audio_player.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadiosScreen extends StatefulWidget {
  const RadiosScreen({super.key});

  @override
  State<RadiosScreen> createState() => _RadiosScreenState();
}

class _RadiosScreenState extends State<RadiosScreen> {
  var ministryController = Get.find<MinistryController>();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filtered list based on the search query
    final filteredRadios = ministryController.radiosList.where((radio) {
      final name = radio['name']?.toLowerCase() ?? "";
      final location = radio['location']?.toLowerCase() ?? "";
      return name.contains(searchQuery.toLowerCase()) ||
          location.contains(searchQuery.toLowerCase());
    }).toList()
      ..sort((a, b) {
        final nameA = a['name']?.toLowerCase() ?? "";
        final nameB = b['name']?.toLowerCase() ?? "";
        return nameA.compareTo(nameB);
      });

    return Scaffold(
      appBar: AppBar(
        title: "radios".tr.text.make(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
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
                    height: 30,
                    width: 0.7 * context.screenWidth,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "search_radios".tr,
                        hintText: "search_radios".tr,
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: filteredRadios.length,
                  (context, index) {
                    return Card(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        onTap: () {
                          if (filteredRadios[index]['radioLink'] != "") {
                            Get.to(
                              () => AudioPlayerScreen(
                                audioUrl: filteredRadios[index]['radioLink']!,
                                audioData: filteredRadios[index],
                              ),
                              transition: Transition.fadeIn,
                            );
                          }
                        },
                        leading: SizedBox(
                          height: 40,
                          width: 40,
                          child: NetworkImageWithLoader(
                              filteredRadios[index]['image']!),
                        ),
                        title: Text(
                          filteredRadios[index]['name']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        subtitle:
                            "Frequency: ${filteredRadios[index]['frequency']} FM"
                                .text
                                .make(),
                        trailing:
                            "${filteredRadios[index]['location']}".text.make(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
