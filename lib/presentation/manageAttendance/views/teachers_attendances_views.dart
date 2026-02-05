import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance_teacher.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../domain/usecases/attendance/download_attendance_teachers_usecase.dart';
import '../bloc/attendance_teacher_cubit.dart';
import '../bloc/attendance_teacher_state.dart';
import '../widgets/card_teacher_attendance.dart';

class TeachersAttendancesViews extends StatelessWidget {
  final bool isAttendace;
  final String date;
  const TeachersAttendancesViews({
    super.key,
    required this.isAttendace,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: SafeArea(
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                var snackbar = SnackBar(
                  content: Text(state.successMessage),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Rekam Data ${isAttendace ? "Kehadiran" : "Kepulangan"} Guru:",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                BlocBuilder<AttendanceTeacherCubit, AttendanceTeacherState>(
                  builder: (context, state) {
                    if (state is AttendanceTeacherLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is AttendanceTeacherLoaded) {
                      return state.teachers.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: height * 0.25),
                              child: const Center(
                                child: Text('Belum ada data yang terekam'),
                              ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return CustomInkWell(
                                      borderRadius: 12,
                                      defaultColor: AppColors.primary,
                                      onTap: () => context
                                          .read<ButtonStateCubit>()
                                          .execute(
                                            usecase:
                                                DownloadAttendanceTeachersUsecase(),
                                            params: ParamAttendanceTeacher(
                                              date: date,
                                              isAttendance: isAttendace,
                                            ),
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Unduh Rekam Data ${isAttendace ? "Kehadiran" : "Kepulangan"} Guru",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.inversePrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.download,
                                              color: AppColors.inversePrimary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return CardTeacherAttendance(
                                    teacher: state.teachers[index - 1],
                                    isAttendance: isAttendace,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: height * 0.02),
                                itemCount: state.teachers.length + 1,
                              ),
                            );
                    }
                    if (state is AttendanceTeacherFailure) {
                      return Text(state.errorMessage);
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
