import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardGuru extends StatelessWidget {
  final String title;
  final String nip;
  const CardGuru({
    super.key,
    required this.title,
    required this.nip,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.45,
      height: height * 0.25,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.285,
              height: height * 0.135,
              child: CachedNetworkImage(
                imageUrl: DisplayImage.displayImageTeacher(title, nip),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(AppImages.guru),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.385,
              height: height * 0.06,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
