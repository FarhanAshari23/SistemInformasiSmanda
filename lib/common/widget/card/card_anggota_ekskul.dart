import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/widget/photo/network_photo.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/murid_detail.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../../domain/entities/auth/user.dart';

class CardAnggotaEkskul extends StatelessWidget {
  final UserEntity? murid;
  final TeacherEntity? pembina;
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
    return Column(
      children: [
        CustomInkWell(
          borderRadius: 16,
          defaultColor: AppColors.secondary,
          onTap: () {
            if (pembina != null) {
              AppNavigator.push(context, TeacherDetail(teachers: pembina!));
            } else {
              AppNavigator.push(context, MuridDetail(user: murid!));
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
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          pembina != null ? pembina?.nama ?? '' : murid?.nama ?? '',
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
