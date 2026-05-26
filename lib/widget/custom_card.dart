import 'package:flutter/material.dart';
import './show_popup.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
       const ShowPopup();
      },
      child: const Icon(Icons.dashboard_customize),
    );
  }
}
