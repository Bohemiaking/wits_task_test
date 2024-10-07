import 'dart:math';
import 'package:flutter/material.dart';

Color generateRandomColor() {
  Random random = Random();
  int maxValue = 0xffffffff;
  int randomValue =
      random.nextInt(maxValue - 0xffffff) + 0xffffff; // Exclude white
  if (randomValue == 0xffffffff) {
    randomValue -= 1; // Avoid white color
  }
  Color randomColor = Color(randomValue);
  return randomColor;
}
