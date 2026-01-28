import 'package:arise_and_shine/components/event_session_card.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var ministryController = Get.find<MinistryController>();

    return Scaffold(
      appBar: AppBar(
        title: "events".tr.text.make(),
        centerTitle: true,
      ),
      body: ministryController.events.isEmpty
          ? Center(
              child: "no_events".tr.text.color(primaryColor).make(),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: ministryController.events.length,
                      itemBuilder: (context, index) {
                        var event = ministryController.events[index];
                        return EventSessionCard(
                          image: event['thumbnail'],
                          title: event['title'],
                          desc: event['description'],
                          date: event['date'],
                          location: event['location'],
                          time: event['time'],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
