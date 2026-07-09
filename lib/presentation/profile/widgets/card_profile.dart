import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/bloc/student/get_student_cubit.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
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
import '../../admin/teacher/views/edit_teacher_detail_view.dart';
import '../views/student/edit_profile_student_view.dart';

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
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
      child: CustomInkWell(
        borderRadius: 12,
        defaultColor: AppColors.secondary,
        onTap: () {
          if (student != null) {
            AppNavigator.push(context, MuridDetail(userId: student?.id ?? 0));
          } else if (teacher != null) {
            AppNavigator.push(
                context, TeacherDetail(teacherId: teacher?.id ?? 0));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    child: NetworkPhoto(
                      width: student != null ? width * 0.245 : width * 0.235,
                      height: student != null
                          ? bodyHeight * 0.15
                          : bodyHeight * 0.14,
                      forceRefresh: true,
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
                              student?.picture ?? '',
                            )
                          : DisplayImage.displayImageTeacher(
                              teacher?.picture ?? '',
                            ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${student != null ? student?.name : teacher?.name ?? ''}",
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${student != null ? student?.nameClass : teacher?.nip}",
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomInkWell(
                  borderRadius: 999,
                  defaultColor: AppColors.primary,
                  onTap: () => AppNavigator.push(
                    context,
                    student != null
                        ? BlocProvider.value(
                            value: context.read<StudentCubit>(),
                            child: EditProfileStudentView(user: student!),
                          )
                        : BlocProvider.value(
                            value: context.read<TeacherCubit>(),
                            child: EditTeacherDetailView(teacher: teacher!),
                          ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
