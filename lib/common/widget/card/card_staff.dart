import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardStaff extends StatelessWidget {
  final TeacherEntity teacher;
  final String? content;
  final bool forceRefresh;
  final Widget page;
  const CardStaff({
    super.key,
    this.content,
    required this.teacher,
    required this.page,
    this.forceRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, page),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.45,
        height: height * 0.25,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NetworkPhoto(
                forceRefresh: forceRefresh,
                width: width * 0.24,
                height: height * 0.115,
                fallbackAsset: teacher.gender == 1
                    ? AppImages.tendikLaki
                    : AppImages.tendikPerempuan,
                imageUrl: DisplayImage.displayImageTeacher(
                  teacher.nama,
                  teacher.nip != '-' ? teacher.nip : teacher.tanggalLahir,
                ),
              ),
              SizedBox(height: height * 0.01),
              SizedBox(
                width: width * 0.4,
                height: height * 0.06,
                child: Center(
                  child: Text(
                    teacher.nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                content != null ? content! : teacher.jabatan,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
