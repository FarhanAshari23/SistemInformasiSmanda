import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../presentation/profile/views/student/profile_student_view.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../../helper/string_helper.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';

class BasicAppbar extends StatelessWidget {
  final bool isBackViewed;
  final bool showLogo;
  final TeacherEntity? teacher;
  final StudentEntity? student;
  final bool isAdmin;

  const BasicAppbar({
    super.key,
    required this.isBackViewed,
    this.showLogo = false,
    this.student,
    this.teacher,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String greeting = _getGreeting(now.hour);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftSection(context),
          !showLogo
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.tertiary,
                      ),
                      child: Image.asset(
                        AppImages.logoSMA,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Smanda Comet",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          _buildRightSection(width, greeting, context),
        ],
      ),
    );
  }

  // Helper untuk menentukan ucapan waktu
  String _getGreeting(int hour) {
    if (hour < 10) return "Pagi";
    if (hour < 16) return "Siang";
    if (hour < 19) return "Sore";
    return "Malam";
  }

  // Widget Sisi Kiri
  Widget _buildLeftSection(BuildContext context) {
    if (isBackViewed) {
      return CustomInkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: 8,
        defaultColor: AppColors.tertiary,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.inversePrimary,
            size: 32,
          ),
        ),
      );
    }

    if (showLogo) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.tertiary,
            ),
            child: Image.asset(
              AppImages.logoSMA,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Smanda\nComet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  // Widget Sisi Kanan
  Widget _buildRightSection(
      double width, String greeting, BuildContext context) {
    if (student != null) {
      String studentNickname = StringHelper.extractName(student?.name ?? '');
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.tertiary,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => AppNavigator.push(
                context,
                ProfileStudentView(studentId: student?.id ?? 0),
              ),
              child: NetworkPhoto(
                width: width * 0.05,
                height: width * 0.05,
                shape: BoxShape.circle,
                fallbackAsset: student?.gender == 1
                    ? AppImages.boyStudent
                    : student?.religion == "Islam"
                        ? AppImages.girlStudent
                        : AppImages.girlNonStudent,
                imageUrl:
                    DisplayImage.displayImageStudent(student?.picture ?? ''),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$greeting, $studentNickname!',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (teacher != null) {
      String teacherNickname =
          StringHelper.getFirstRealName(teacher?.name ?? '');
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.tertiary,
        ),
        child: Text(
          'Selamat $greeting $teacherNickname!',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.inversePrimary,
          ),
        ),
      );
    }

    if (isAdmin == true) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.tertiary,
        ),
        child: Text(
          'Selamat $greeting Admin!',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.inversePrimary,
          ),
        ),
      );
    }
    return const SizedBox(
      width: 40,
      height: 40,
    );
  }
}
