import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final title;
  VoidCallback ontap;
  Icon? icon;
  CustomButton(
      {super.key, required this.title, this.icon, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: ontap,
        child: Row(
          children: [icon ?? SizedBox(), Text(title)],
        ));
  }
}
