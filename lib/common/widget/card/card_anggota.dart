import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/auth/user.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

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
            NetworkPhoto(
              width: 80,
              height: 80,
              fallbackAsset: murid != null
                  ? murid!.gender == 1
                      ? AppImages.boyStudent
                      : murid!.agama == "Islam"
                          ? AppImages.girlStudent
                          : AppImages.girlNonStudent
                  : pembina!.gender == 1
                      ? AppImages.guruLaki
                      : AppImages.guruPerempuan,
              imageUrl: murid != null
                  ? DisplayImage.displayImageStudent(
                      murid?.nama ?? '', murid?.nisn ?? '')
                  : DisplayImage.displayImageTeacher(
                      pembina?.nama ?? '',
                      pembina?.nip != '-'
                          ? pembina?.nip ?? ''
                          : pembina?.tanggalLahir ?? '',
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
