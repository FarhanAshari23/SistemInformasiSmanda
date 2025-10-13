import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardStaff extends StatelessWidget {
  final String title;
  final String content;
  final int gender;
  final Widget page;
  const CardStaff({
    super.key,
    required this.title,
    required this.content,
    required this.page,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, page),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.45,
        height: height * 0.25,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.24,
                height: height * 0.115,
                child: CachedNetworkImage(
                  imageUrl: DisplayImage.displayImageStaff(title),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Image.asset(gender == 1
                      ? AppImages.tendikLaki
                      : AppImages.tendikPerempuan),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: height * 0.01),
              SizedBox(
                width: width * 0.4,
                height: height * 0.06,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
