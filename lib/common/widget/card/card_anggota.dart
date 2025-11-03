import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../../domain/entities/auth/user.dart';

class CardAnggota extends StatelessWidget {
  final String title;
  final String desc;
  final UserEntity? murid;
  final TeacherEntity? pembina;
  final Function() onTap;
  const CardAnggota({
    super.key,
    required this.title,
    required this.desc,
    required this.onTap,
    this.murid,
    this.pembina,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.primary,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    murid != null
                        ? murid!.gender == 1
                            ? AppImages.boyStudent
                            : murid!.agama == "Islam"
                                ? AppImages.girlStudent
                                : AppImages.girlNonStudent
                        : pembina!.gender == 1
                            ? AppImages.guruLaki
                            : AppImages.guruPerempuan,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
