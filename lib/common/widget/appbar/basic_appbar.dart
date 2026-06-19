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
  final bool? isLogout;
  final TeacherEntity? teacher;
  final StudentEntity? student;
  const BasicAppbar({
    super.key,
    required this.isBackViewed,
    this.isLogout,
    this.student,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String teacherNickname = StringHelper.getFirstRealName(teacher?.name ?? '');
    String studentNickname = StringHelper.extractName(student?.name ?? '');
    String greeting;
    int hour = now.hour;
    if (hour < 10) {
      greeting = "Pagi";
    } else if (hour < 16) {
      greeting = "Siang";
    } else if (hour < 19) {
      greeting = "Sore";
    } else {
      greeting = "Malam";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isBackViewed
              ? CustomInkWell(
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
                )
              : const SizedBox(),
          student != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.tertiary,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => AppNavigator.push(
                          context,
                          ProfileStudentView(
                            studentId: student?.id ?? 0,
                          ),
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
                          imageUrl: DisplayImage.displayImageStudent(
                              student?.picture ?? ''),
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
                )
              : teacher != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
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
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }
}
