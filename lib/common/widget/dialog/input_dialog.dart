import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../button/basic_button.dart';

class InputDialog extends StatelessWidget {
  final double height;
  final String title, hintText, buttonTitle;
  final TextEditingController controller;
  final Function() onTap;
  const InputDialog({
    super.key,
    required this.height,
    required this.title,
    required this.controller,
    required this.hintText,
    required this.onTap,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          height: height * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextField(
                  controller: controller,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: '$hintText :',
                  ),
                ),
                SizedBox(height: height * 0.02),
                BasicButton(
                  onPressed: onTap,
                  title: buttonTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
