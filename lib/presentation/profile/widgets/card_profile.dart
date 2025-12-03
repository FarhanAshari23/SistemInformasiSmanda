import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/profile/profile_info_cubit.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../views/edit_profile_student_view.dart';
import '../views/edit_profile_teacher_view.dart';

class CardProfile extends StatelessWidget {
  final UserEntity? student;
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
    final birthDate = teacher?.tanggalLahir;

    final nipOrBirthDate =
        (nip != null && nip.isNotEmpty && nip != '-') ? nip : (birthDate ?? '');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      padding: const EdgeInsets.only(bottom: 18, top: 18, right: 12, left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondary,
      ),
      child: Row(
        children: [
          NetworkPhoto(
            width: width * 0.3,
            height: height * 0.15,
            fallbackAsset: student != null
                ? student?.gender == 1
                    ? AppImages.boyStudent
                    : student?.agama == "Islam"
                        ? AppImages.girlStudent
                        : AppImages.girlNonStudent
                : teacher?.gender == 1
                    ? AppImages.guruLaki
                    : AppImages.guruPerempuan,
            imageUrl: student != null
                ? DisplayImage.displayImageStudent(
                    student?.nama ?? '',
                    student?.nisn ?? '',
                  )
                : DisplayImage.displayImageTeacher(
                    teacher?.nama ?? '',
                    nipOrBirthDate,
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
                        (student != null ? student?.nama : teacher?.nama) ?? '',
                        style: const TextStyle(
                          color: AppColors.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      (student != null ? student?.kelas : teacher?.nip) ?? '',
                      style: const TextStyle(
                        color: AppColors.inversePrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CustomInkWell(
                  borderRadius: 999,
                  defaultColor: AppColors.primary,
                  onTap: () => AppNavigator.push(
                    context,
                    BlocProvider.value(
                      value: context.read<ProfileInfoCubit>(),
                      child: student != null
                          ? EditProfileStudentView(user: student!)
                          : EditProfileTeacherView(teacher: teacher!),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
