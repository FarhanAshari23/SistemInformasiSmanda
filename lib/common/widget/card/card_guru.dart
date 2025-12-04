import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardGuru extends StatelessWidget {
  final TeacherEntity teacher;
  final bool forceRefresh;
  const CardGuru({
    super.key,
    required this.teacher,
    this.forceRefresh = true,
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
            NetworkPhoto(
              forceRefresh: forceRefresh,
              width: width * 0.285,
              height: height * 0.135,
              fallbackAsset: teacher.gender == 1
                  ? AppImages.guruLaki
                  : AppImages.guruPerempuan,
              imageUrl: DisplayImage.displayImageTeacher(teacher.nama,
                  teacher.nip != "-" ? teacher.nip : teacher.tanggalLahir),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.385,
              height: height * 0.06,
              child: Center(
                child: Text(
                  teacher.nama,
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
