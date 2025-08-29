import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../helper/display_image.dart';

class CardUser extends StatelessWidget {
  final String name;
  final String nisn;
  final int gender;
  final VoidCallback? onTap;
  const CardUser({
    super.key,
    required this.name,
    required this.nisn,
    required this.onTap,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: onTap,
      child: SizedBox(
        width: width * 0.7,
        height: bodyHeight * 0.175,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.235,
                    height: bodyHeight * 0.14,
                    child: CachedNetworkImage(
                      imageUrl: DisplayImage.displayImageStudent(name, nisn),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        gender == 1
                            ? AppImages.boyStudent
                            : AppImages.girlStudent,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.465,
                          height: bodyHeight * 0.06,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          nisn,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: width * 0.1,
                height: bodyHeight * 0.05,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(12)),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
