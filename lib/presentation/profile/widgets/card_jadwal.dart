import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardJadwal extends StatelessWidget {
  final int urutan;
  final String jam;
  final String kegiatan;
  final String pelaksana;
  const CardJadwal({
    super.key,
    required this.jam,
    required this.kegiatan,
    required this.pelaksana,
    required this.urutan,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: height * 0.15,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.background,
        border: Border.all(
          width: 1.5,
          color: AppColors.primary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
                child: Center(
                  child: Text(
                    urutan.toString(),
                    style: const TextStyle(
                      color: AppColors.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppImages.clock,
                          width: width * 0.08,
                          height: height * 0.02,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          jam,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.task,
                          width: width * 0.08,
                          height: height * 0.02,
                        ),
                        SizedBox(width: width * 0.01),
                        Text(
                          kegiatan,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              pelaksana,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
