import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  final String? text;
  final Color? backgroundColor;
  final int? seconds;
  CustomSnackBar(
      {Key? key,
      required this.text,
      this.backgroundColor = Colors.white,
      this.seconds = 4})
      : super(
          key: key,
          content: Text(
            text!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: backgroundColor!,
          duration: Duration(seconds: seconds!),
        );
}
