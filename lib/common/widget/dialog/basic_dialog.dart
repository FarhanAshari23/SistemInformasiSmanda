import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../button/basic_button.dart';

class BasicDialog extends StatelessWidget {
  final double width, height;
  final String splashImage, buttonTitle, mainTitle;
  final Function() onPressed;
  const BasicDialog({
    super.key,
    required this.width,
    required this.height,
    required this.splashImage,
    required this.mainTitle,
    required this.buttonTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.inversePrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: width * 0.7,
        height: height * 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.6,
              height: height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(splashImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                mainTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.02),
            BasicButton(
              onPressed: onPressed,
              title: buttonTitle,
            ),
          ],
        ),
      ),
    );
  }
}
