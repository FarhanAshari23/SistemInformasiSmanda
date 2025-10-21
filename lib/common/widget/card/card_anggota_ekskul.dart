import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: height * 0.125,
          height: height * 0.125,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.secondary,
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(height * 0.06),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage(AppImages.tendikLaki),
                  fit: BoxFit.fill,
                ),
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
