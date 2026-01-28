import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<dynamic> socialLinks;

  const SocialDialog({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.socialLinks,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: iconColor,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...socialLinks.map((link) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  onTap: () => _openLink(link['link']),
                  title: Text(
                    link['title'],
                    style: const TextStyle(color: Colors.blue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: const Icon(
                    Icons.link,
                    color: Colors.blue,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Function to open links in the browser
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }
}

void showSocialDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required List<dynamic> socialLinks,
  required iconColor,
}) {
  showDialog(
    context: context,
    builder: (context) => SocialDialog(
      iconColor: iconColor,
      icon: icon,
      title: title,
      socialLinks: socialLinks,
    ),
  );
}
