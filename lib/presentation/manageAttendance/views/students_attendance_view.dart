import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/card_student_attendance.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/list_kelas_duabelas_attendance.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/list_kelas_sebelas_attendance.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../domain/usecases/attendance/get_attendance_students.dart';
import '../bloc/attendance_student_cubit.dart';
import '../bloc/attendance_student_state.dart';
import '../widgets/list_kelas_sepuluh_attendances.dart';

class StudentAttendancesView extends StatelessWidget {
  final int kelas;
  final String date;
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
      body: BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
        builder: (context, state) {
          if (state is KelasDisplayLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is KelasDisplayLoaded) {
            final kelasSepuluh =
                state.kelas.where((element) => element.degree == 10).toList();
            final kelasSebelas =
                state.kelas.where((element) => element.degree == 11).toList();
            final kelasDuabelas =
                state.kelas.where((element) => element.degree == 12).toList();
            return BlocProvider(
              create: (context) => AttendanceStudentCubit(
                  usecase: GetAttendanceStudentsUsecase())
                ..displayAttendanceStudent(
                  params: ParamAttendanceEntity(
                    date: date,
                    kelas: kelas == 10
                        ? kelasSepuluh[0].kelas
                        : kelas == 11
                            ? kelasSebelas[0].kelas
                            : kelasDuabelas[0].kelas,
                  ),
                ),
              child: SafeArea(
                child: Column(
                  children: [
                    const BasicAppbar(
                      isBackViewed: true,
                      isProfileViewed: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: kelas == 10
                          ? ListKelasSepuluhAttendances(date: date)
                          : kelas == 11
                              ? ListKelasSebelasAttendance(date: date)
                              : ListKelasDuabelasAttendance(date: date),
                    ),
                    SizedBox(height: height * 0.04),
                    BlocBuilder<AttendanceStudentCubit, AttendanceStudentState>(
                      builder: (context, state) {
                        if (state is AttendanceStudentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is AttendanceStudentLoaded) {
                          return state.students.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemBuilder: (context, index) {
                                      return CardStudentAttendance(
                                        student: state.students[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: height * 0.02),
                                    itemCount: state.students.length,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: height * 0.25),
                                  child: const Center(
                                    child: Text('Belum ada data yang terekam'),
                                  ),
                                );
                        }
                        if (state is AttendanceStudentFailure) {
                          return Center(
                            child:
                                Text('Something wrongs: ${state.errorMessage}'),
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
    );
  }
}
