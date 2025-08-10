import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardPrimary extends StatelessWidget {
  final String title;
  final Widget widget;
  const CardPrimary({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.43,
      height: height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.inversePrimary,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () => AppNavigator.push(context, widget),
              child: Container(
                width: width * 0.15,
                height: height * 0.07,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(8),
                  ),
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Image.asset(AppImages.arrowRight),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
