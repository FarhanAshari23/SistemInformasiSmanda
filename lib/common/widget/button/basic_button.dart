// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class BasicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const BasicButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.45,
        height: height * 0.1,
        color: AppColors.primary,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
