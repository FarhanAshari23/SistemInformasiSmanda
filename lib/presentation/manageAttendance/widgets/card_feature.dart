import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardFeature extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onpressed;

  const CardFeature({
    super.key,
    required this.title,
    required this.image,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: width * 0.435,
        height: height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            children: [
              Container(
                width: width * 0.25,
                height: height * 0.12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Image.asset(
                    image,
                    scale: 2.5,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.inversePrimary,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
