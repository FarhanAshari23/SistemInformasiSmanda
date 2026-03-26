import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../common/widget/detail/murid_detail.dart';
import '../../../common/widget/detail/teacher_detail.dart';
import '../views/edit_profile_student_view.dart';

class CardProfile extends StatelessWidget {
  final StudentEntity? student;
  final TeacherEntity? teacher;
  const CardProfile({
    super.key,
    this.student,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final nip = teacher?.nip;
    final birthDate = teacher?.birthDate;

    final nipOrBirthDate = (nip != null && nip.isNotEmpty)
        ? nip
        : (DateFormat('d MMMM yyyy', "id_ID").format(birthDate!));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.015),
      child: CustomInkWell(
        borderRadius: 16,
        defaultColor: AppColors.secondary,
        onTap: () => AppNavigator.push(
          context,
          student != null
              ? MuridDetail(userId: student!.id!)
              : TeacherDetail(teacherId: teacher!.id!),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 18, top: 18, right: 12, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkPhoto(
                width: width * 0.3,
                height: height * 0.15,
                fallbackAsset: student != null
                    ? student?.gender == 1
                        ? AppImages.boyStudent
                        : student?.religion == "Islam"
                            ? AppImages.girlStudent
                            : AppImages.girlNonStudent
                    : teacher?.gender == 1
                        ? AppImages.guruLaki
                        : AppImages.guruPerempuan,
                imageUrl: student != null
                    ? DisplayImage.displayImageStudent(
                        student?.name ?? '',
                        student?.nisn ?? '',
                      )
                    : DisplayImage.displayImageTeacher(
                        teacher?.name ?? '',
                        nipOrBirthDate.toString(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 19, left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          height: height * 0.055,
                          child: Text(
                            (student != null ? student?.name : teacher?.name) ??
                                '',
                            style: const TextStyle(
                              color: AppColors.inversePrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          (student != null
                                  ? student?.nameClass
                                  : teacher?.nip) ??
                              '',
                          style: const TextStyle(
                            color: AppColors.inversePrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomInkWell(
                      borderRadius: 999,
                      defaultColor: AppColors.primary,
                      onTap: () => AppNavigator.push(
                        context,
                        EditProfileStudentView(user: student),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          student != null
                              ? Icons.edit
                              : Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
