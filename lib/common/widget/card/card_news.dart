import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardNews extends StatelessWidget {
  final String title;
  final String from;
  final String to;
  final VoidCallback onPressed;
  const CardNews({
    super.key,
    required this.title,
    required this.from,
    required this.to,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: bodyHeight * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.inversePrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.65,
                  height: bodyHeight * 0.065,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: bodyHeight * 0.008),
                SizedBox(
                  width: width * 0.65,
                  height: bodyHeight * 0.065,
                  child: Text(
                    'Dari $from untuk $to',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: onPressed,
              child: Container(
                width: width * 0.135,
                height: bodyHeight * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.secondary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
