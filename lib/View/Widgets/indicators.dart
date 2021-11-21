import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatelessWidget {
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final double? value;
  const CustomCircularIndicator(
      {Key? key, this.color, this.backgroundColor, this.size = 4, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: this.backgroundColor != null
            ? this.backgroundColor
            : Colors.transparent,
        color: this.color != null ? this.color : Colors.white,
        strokeWidth: this.size!,
        value: this.value,
      ),
    );
  }
}
