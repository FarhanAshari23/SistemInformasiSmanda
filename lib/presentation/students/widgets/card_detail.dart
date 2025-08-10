import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardDetailSiswa extends StatelessWidget {
  final String title;
  final String content;
  const CardDetailSiswa({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.45,
      height: bodyHeight * 0.295,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: width * 0.45,
            height: bodyHeight * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.secondary,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.inversePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: bodyHeight * 0.215,
            child: Container(
              width: width * 0.25,
              height: bodyHeight * 0.065,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.tertiary,
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.inversePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
