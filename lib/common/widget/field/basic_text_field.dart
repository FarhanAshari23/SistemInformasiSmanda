import 'package:flutter/material.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BasicTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
