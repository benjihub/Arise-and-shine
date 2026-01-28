import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Map<String, Map<String, String>> translations = {};

  @override
  Map<String, Map<String, String>> get keys => translations;

  static Future<void> loadTranslations() async {
    final enJson = await rootBundle.loadString('assets/lang/en.json');
    final swJson = await rootBundle.loadString('assets/lang/sw.json');

    translations = {
      'en': Map<String, String>.from(json.decode(enJson)),
      'sw': Map<String, String>.from(json.decode(swJson)),
    };
  }
}
