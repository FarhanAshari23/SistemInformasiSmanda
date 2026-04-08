import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/advisor.dart';
import '../../../domain/entities/ekskul/member.dart';
import '../detail/murid_detail.dart';
import '../detail/teacher_detail.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';

class CardAnggotaEkskul extends StatelessWidget {
  final MemberEntity? murid;
  final AdvisorEntity? pembina;
  final String jabatan;
  const CardAnggotaEkskul({
    super.key,
    this.murid,
    this.pembina,
    required this.jabatan,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String imageUrl = murid != null
        ? DisplayImage.displayImageStudent(murid?.picture ?? '')
        : DisplayImage.displayImageTeacher(
            pembina?.picture ?? '',
          );
    String fallbackAsset = murid != null
        ? murid!.gender == 1
            ? AppImages.boyStudent
            : murid!.religion == "Islam"
                ? AppImages.girlStudent
                : AppImages.girlNonStudent
        : pembina!.gender == 1
            ? AppImages.guruLaki
            : AppImages.guruPerempuan;

    return Column(
      children: [
        CustomInkWell(
          borderRadius: 16,
          defaultColor: AppColors.secondary,
          onTap: () {
            if (pembina != null) {
              AppNavigator.push(
                  context, TeacherDetail(teacherId: pembina!.id!));
            } else {
              AppNavigator.push(context, MuridDetail(userId: murid!.id!));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            width: height * 0.125,
            height: height * 0.125,
            child: Center(
              child: NetworkPhoto(
                width: height * 0.1,
                height: height * 0.1,
                fallbackAsset: fallbackAsset,
                imageUrl: imageUrl,
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          pembina != null ? pembina?.name ?? '' : murid?.name ?? '',
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
