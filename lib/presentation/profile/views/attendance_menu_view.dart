import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_basic.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/see_all_data_attandance_students.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'schedule_attendance_teacher_view.dart';

class AttendanceMenuView extends StatelessWidget {
  final TeacherEntity teacher;
  const AttendanceMenuView({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: false),
            const Text(
              "Data absen mana yang ingin kamu lihat?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardBasic(
                  title: "Diri Sendiri\n(${teacher.nama})",
                  image: AppImages.teacher,
                  onpressed: () => AppNavigator.push(
                    context,
                    ScheduleAttendanceTeacherView(
                      teacher: teacher,
                    ),
                  ),
                ),
                CardBasic(
                  title: "Seluruh Murid",
                  image: AppImages.students,
                  onpressed: () => AppNavigator.push(
                    context,
                    const SeeAllDataAttandanceStudents(isProfileTeacher: true),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
