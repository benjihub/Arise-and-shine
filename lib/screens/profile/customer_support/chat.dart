import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'.tr),
        centerTitle: true,
      ),
      body: const Center(child: Text('Chat feature coming soon!')),
    );
  }
}
