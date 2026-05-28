import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Color fondColor;
  final Color textColor;
  final VoidCallback? onpress;

  const Button({
    super.key,
    required this.title,
    required this.fondColor,
    required this.textColor,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: fondColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onpress,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
