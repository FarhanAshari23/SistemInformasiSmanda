import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class FieldNews extends StatelessWidget {
  final String title;
  final String hinttext;
  final int line;
  final TextEditingController controller;
  const FieldNews({
    super.key,
    required this.title,
    required this.controller,
    required this.hinttext,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: height * 0.01),
        TextField(
          controller: controller,
          autocorrect: false,
          maxLines: line,
          decoration: InputDecoration(hintText: hinttext),
        )
      ],
    );
  }
}
