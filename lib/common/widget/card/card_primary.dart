import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

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
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, widget),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.43,
        height: height * 0.3,
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
            )
          ],
        ),
      ),
    );
  }
}
