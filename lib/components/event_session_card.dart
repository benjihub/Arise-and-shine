import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:flutter/material.dart';

class EventSessionCard extends StatelessWidget {
  const EventSessionCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.desc,
  });
  final String image, title, location, date, time, desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: NetworkImageWithLoader(image),
          ),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                  maxLines: 1,
                ),
                Text(
                  desc,
                  style: const TextStyle(
                      color: Colors.grey, overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.red,
                              size: 15,
                            ),
                            2.widthBox,
                            date.text.size(1).light.make(),
                          ],
                        ),
                        1.heightBox,
                        Row(
                          children: [
                            const Icon(
                              Icons.watch,
                              color: Colors.red,
                              size: 15,
                            ),
                            2.widthBox,
                            time.text.size(1).light.make(),
                          ],
                        ),
                      ],
                    ),
                    10.widthBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.room,
                              size: 15,
                              color: Colors.red,
                            ),
                            2.widthBox,
                            location.text.size(1).light.ellipsis.make(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).box.transparent.p4.make().onTap(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: NetworkImageWithLoader(image),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(desc),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(date),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.watch, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(time),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.room, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(location)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
