import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static showSnackBar(String message) {
    return ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
