import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardKepalaSekolah extends StatelessWidget {
  final String title;
  final String nisn;
  final Widget page;
  const CardKepalaSekolah({
    super.key,
    required this.title,
    required this.nisn,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, page),
      borderRadius: 16,
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: double.infinity,
        height: height * 0.2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.31,
                height: height * 0.15,
                child: CachedNetworkImage(
                  imageUrl: DisplayImage.displayImageTeacher(title, nisn),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      Image.asset(AppImages.guru),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: width * 0.5,
                height: height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            height: height * 0.1,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.inversePrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
