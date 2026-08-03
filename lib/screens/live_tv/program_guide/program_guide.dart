import 'package:arise_and_shine/components/top_home_button.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramLineup extends StatefulWidget {
  const ProgramLineup({super.key});

  @override
  State<ProgramLineup> createState() => _ProgramLineupState();
}

class _ProgramLineupState extends State<ProgramLineup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentDayIndex;

  @override
  void initState() {
    super.initState();
    // Get the current day index (0 - Mon, 6 - Sun)
    _currentDayIndex = DateTime.now().weekday - 1;
    _tabController =
        TabController(length: 7, vsync: this, initialIndex: _currentDayIndex);
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = [
      "Mon",
      "Tue",
      "Wed",
      "Thur",
      "Fri",
      "Sat",
      "Sun"
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Program Lineup", style: TextStyle(color: Colors.white)),
            topHomeButton(
              color: lightGreyColor,
              textColor: whiteColor,
              buttonWidth: 0.26 * context.screenWidth,
              context: context,
              icon: Icons.volunteer_activism,
              title: "give".tr,
              onPress: () {
                launchUrl(
                  Uri.parse('https://flutterwave.com/donate/uaqazpxgxebr'),
                  mode: LaunchMode.inAppWebView,
                );
              },
            ),
          ],
        ),
        backgroundColor: darkGreyColor,
        bottom: TabBar(
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.white,
          controller: _tabController,
          tabs: daysOfWeek.map((day) => Tab(text: day)).toList(),
        ),
        leadingWidth: 0,
        leading: const SizedBox(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TabBarView with Programs for each Day
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: daysOfWeek.map((day) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tv_programs')
                        .doc(day)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: loadingIndicator(color: goldenColor),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data?.data() == null) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'No programs available for $day.',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        );
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final programs = List<Map<String, dynamic>>.from(
                          data['programs'] as List)
                        ..sort((a, b) =>
                            a['sortableTime'].compareTo(b['sortableTime']));

                      DateTime now = DateTime.now();

                      // Create a scroll controller that we can keep reference to
                      final ScrollController scrollController =
                          ScrollController();

                      // Find the current program index
                      int currentProgramIndex = programs.indexWhere((program) {
                        final sortableTime = program['sortableTime'] ?? '';
                        DateTime parsedSortableTime;
                        try {
                          final timeParts = sortableTime.split(':');
                          final hour = int.parse(timeParts[0]);
                          final minute = int.parse(timeParts[1]);
                          parsedSortableTime = DateTime(
                              now.year, now.month, now.day, hour, minute);

                          // Get next program time
                          DateTime nextProgramTime;
                          if (programs.indexOf(program) < programs.length - 1) {
                            final nextProgram =
                                programs[programs.indexOf(program) + 1];
                            final nextSortableTime =
                                nextProgram['sortableTime'];
                            final nextTimeParts = nextSortableTime.split(':');
                            final nextHour = int.parse(nextTimeParts[0]);
                            final nextMinute = int.parse(nextTimeParts[1]);
                            nextProgramTime = DateTime(now.year, now.month,
                                now.day, nextHour, nextMinute);
                          } else {
                            nextProgramTime = parsedSortableTime
                                .add(const Duration(hours: 1));
                          }

                          return now.isAfter(parsedSortableTime) &&
                              now.isBefore(nextProgramTime);
                        } catch (e) {
                          return false;
                        }
                      });

                      // Scroll to current program after build
                      if (currentProgramIndex != -1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          scrollController.animateTo(
                            currentProgramIndex *
                                70.0, // Approximate height of ListTile
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        });
                      }

                      return ListView.builder(
                        itemCount: programs.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final program = programs[index];
                          final title = program['title'] ?? 'No Title';
                          final description =
                              program['description'] ?? 'No Description';
                          final time = program['time'] ?? 'No Time';
                          final sortableTime = program['sortableTime'] ?? '';

                          DateTime parsedSortableTime;
                          try {
                            final timeParts = sortableTime.split(':');
                            final hour = int.parse(timeParts[0]);
                            final minute = int.parse(timeParts[1]);
                            parsedSortableTime = DateTime(
                                now.year, now.month, now.day, hour, minute);
                          } catch (e) {
                            parsedSortableTime = DateTime.now();
                            debugPrint('Error parsing time: $sortableTime');
                          }

                          // Get next program time
                          DateTime nextProgramTime;
                          if (index < programs.length - 1) {
                            final nextProgram = programs[index + 1];
                            final nextSortableTime =
                                nextProgram['sortableTime'];
                            final nextTimeParts = nextSortableTime.split(':');
                            final nextHour = int.parse(nextTimeParts[0]);
                            final nextMinute = int.parse(nextTimeParts[1]);
                            nextProgramTime = DateTime(now.year, now.month,
                                now.day, nextHour, nextMinute);
                          } else {
                            // For the last program, assume it runs for 1 hour
                            nextProgramTime = parsedSortableTime
                                .add(const Duration(hours: 1));
                          }

                          // Check if current time falls between program start and next program
                          bool isNow = now.isAfter(parsedSortableTime) &&
                              now.isBefore(nextProgramTime);

                          return ListTile(
                            key: isNow ? const Key('current_program') : null,
                            tileColor: isNow
                                ? const Color.fromARGB(155, 3, 32, 252)
                                : null,
                            leading: const Icon(Icons.tv, color: Colors.white),
                            title: Text(
                              title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              description,
                              style: const TextStyle(color: Colors.white60),
                            ),
                            trailing: Text(
                              time,
                              style: const TextStyle(color: Colors.white60),
                            ),
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
