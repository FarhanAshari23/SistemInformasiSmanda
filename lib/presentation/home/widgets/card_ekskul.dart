import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardEkskul extends StatelessWidget {
  final String title;
  const CardEkskul({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: height * 0.25,
          color: Colors.white,
          child: Center(
            child: SizedBox(
              width: double.infinity,
              height: height * 0.22,
              child: CachedNetworkImage(
                imageUrl: DisplayImage.displayImageEkskul(title),
                cacheKey: DisplayImage.displayImageEkskul(title),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(AppImages.splashEkskul),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: height * 0.15,
          color: AppColors.secondary,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.inversePrimary,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
