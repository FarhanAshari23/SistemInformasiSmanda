import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../inkwell/custom_inkwell.dart';
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
    String fallbackAsset =
        teacher.gender == 1 ? AppImages.tendikLaki : AppImages.tendikPerempuan;

    return CustomInkWell(
      onTap: () => AppNavigator.push(context, page),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkPhoto(
                width: width * 0.24,
                height: height * 0.115,
                fallbackAsset: fallbackAsset,
                imageUrl: DisplayImage.displayImageTeacher(
                    teacher.name!,
                    teacher.nip != null
                        ? teacher.nip!
                        : DateFormat('d MMMM yyyy').format(teacher.birthDate!)),
              ),
            ),
            SizedBox(height: height * 0.01),
            Column(
              children: [
                Center(
                  child: Text(
                    teacher.name ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  content != null ? content! : teacher.tasksName!.join(","),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
