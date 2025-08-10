import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardActivity extends StatelessWidget {
  final Widget page;
  final String title;
  final String image;
  const CardActivity({
    super.key,
    required this.image,
    required this.title,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Container(
      height: bodyHeight * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
            child: Row(
              children: [
                Container(
                  width: width * 0.195,
                  height: bodyHeight * 0.095,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tertiary,
                  ),
                  child: Center(
                    child: Image.asset(
                      image,
                      width: width * 0.125,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.035),
                SizedBox(
                  width: width * 0.425,
                  height: bodyHeight * 0.15,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => AppNavigator.push(context, page),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Image.asset(AppImages.arrowRight),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
