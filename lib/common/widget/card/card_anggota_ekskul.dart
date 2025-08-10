import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardAnggotaEkskul extends StatelessWidget {
  final String name;
  final String jabatan;
  final String namaEkskul;
  const CardAnggotaEkskul({
    super.key,
    required this.name,
    required this.jabatan,
    required this.namaEkskul,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width * 0.3,
          height: height * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.secondary,
          ),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: DisplayImage.displayImageMemberEkskul(
                    name, namaEkskul, jabatan),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(AppImages.tendik),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: height * 0.005),
        Text(
          jabatan,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
