import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardKepalaSekolah extends StatelessWidget {
  final String title;
  final String nisn;
  final int gender;
  final Widget page;
  const CardKepalaSekolah({
    super.key,
    required this.title,
    required this.nisn,
    required this.page,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, page),
      borderRadius: 16,
      defaultColor: AppColors.secondary,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 0.31,
              height: height * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    gender == 1 ? AppImages.guruLaki : AppImages.guruPerempuan,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nisn,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
