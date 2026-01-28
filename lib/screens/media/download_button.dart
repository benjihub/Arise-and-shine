import 'package:arise_and_shine/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DownloadButton extends StatefulWidget {
  final String imageUrl;

  const DownloadButton({super.key, required this.imageUrl});

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool isDownloading = false;
  double progress = 0.0;

  Future<void> downloadImage() async {
    setState(() {
      isDownloading = true;
      progress = 0.0;
    });

    try {
      final dio = Dio();
      final dir = await getExternalStorageDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '${dir!.path}/image_$timestamp.jpg';

      await dio.download(
        widget.imageUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() => progress = received / total);
          }
        },
      );

      Get.snackbar(
        'Success',
        'Image saved successfully',
        backgroundColor: primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isDownloading = false;
        progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.download,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: isDownloading ? null : downloadImage,
          ),
          if (isDownloading)
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
        ],
      ),
    );
  }
}
