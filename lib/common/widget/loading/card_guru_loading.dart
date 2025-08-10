import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardGuruLoading extends StatelessWidget {
  const CardGuruLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.45,
      height: height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 0.24,
              height: height * 0.115,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.inversePrimary,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.4,
              height: height * 0.06,
              child: const Center(
                child: Text(
                  'Tunggu Sebentar...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            const Text(
              'Tunggu sebentar...',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
