import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../../common/bloc/kelas/kelas_navigation.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/attandance/attendance_student.dart';
import '../../../../domain/usecases/attendance/download_attendance_students_usecase.dart';
import '../../../../domain/usecases/attendance/get_attendance_students.dart';
import '../bloc/attendance_student_cubit.dart';
import '../bloc/attendance_student_state.dart';
import '../widgets/card_student_attendance.dart';
import '../widgets/list_kelas_duabelas_attendance.dart';
import '../widgets/list_kelas_sebelas_attendance.dart';
import '../widgets/list_kelas_sepuluh_attendances.dart';

class StudentAttendancesView extends StatelessWidget {
  final int kelas;
  final DateTime date;
  const StudentAttendancesView({
    super.key,
    required this.date,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (context) => KelasNavigationCubit(),
          ),
        ],
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
          child: BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
            builder: (context, state) {
              if (state is KelasDisplayLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is KelasDisplayLoaded) {
                final kelasSepuluh = state.kelas
                    .where((element) => element.degree == 10)
                    .toList();
                final kelasSebelas = state.kelas
                    .where((element) => element.degree == 11)
                    .toList();
                final kelasDuabelas = state.kelas
                    .where((element) => element.degree == 12)
                    .toList();
                return BlocProvider(
                  create: (context) => AttendanceStudentCubit(
                      usecase: GetAttendanceStudentsUsecase())
                    ..displayAttendanceStudent(
                      params: AttendanceStudentEntity(
                        date: date,
                        className: kelas == 10
                            ? kelasSepuluh[0].className
                            : kelas == 11
                                ? kelasSebelas[0].className
                                : kelasDuabelas[0].className,
                      ),
                    ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        const BasicAppbar(isBackViewed: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: kelas == 10
                              ? ListKelasSepuluhAttendances(date: date)
                              : kelas == 11
                                  ? ListKelasSebelasAttendance(date: date)
                                  : ListKelasDuabelasAttendance(date: date),
                        ),
                        SizedBox(height: height * 0.04),
                        BlocBuilder<AttendanceStudentCubit,
                            AttendanceStudentState>(
                          builder: (context, state) {
                            if (state is AttendanceStudentLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is AttendanceStudentLoaded) {
                              return Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return CustomInkWell(
                                        borderRadius: 12,
                                        defaultColor: AppColors.primary,
                                        onTap: () {
                                          int classNavigation = context
                                              .read<KelasNavigationCubit>()
                                              .state;

                                          context
                                              .read<ButtonStateCubit>()
                                              .execute(
                                                usecase:
                                                    DownloadAttendanceStudentsUsecase(),
                                                params: AttendanceStudentEntity(
                                                  date: date,
                                                  className: kelas == 10
                                                      ? kelasSepuluh[
                                                              classNavigation]
                                                          .className
                                                      : kelas == 11
                                                          ? kelasSebelas[
                                                                  classNavigation]
                                                              .className
                                                          : kelasDuabelas[
                                                                  classNavigation]
                                                              .className,
                                                ),
                                              );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 8.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Unduh Rekam Data Kehadiran Siswa",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.inversePrimary,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(
                                                Icons.download,
                                                color: AppColors.inversePrimary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return CardStudentAttendance(
                                      student: state.students[index - 1],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: height * 0.02),
                                  itemCount: state.students.length + 1,
                                ),
                              );
                            }
                            if (state is AttendanceStudentFailure) {
                              if (state.errorMessage ==
                                  "Something error: (null):(404):Data kelas tidak ditemukan") {
                                return Padding(
                                  padding: EdgeInsets.only(top: height * 0.25),
                                  child: const Center(
                                    child: Text('Belum ada data yang terekam'),
                                  ),
                                );
                              }
                              return Center(
                                child: Text(
                                    'Something wrongs: ////${state.errorMessage}'),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
