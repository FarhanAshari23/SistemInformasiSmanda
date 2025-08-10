import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/classroom.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/list_kelas_duabelas_attendance.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../domain/usecases/attendance/get_attendance_students.dart';
import '../bloc/attendance_student_cubit.dart';
import '../bloc/attendance_student_state.dart';
import '../widgets/card_user_attendance.dart';

class AttendancesKelasDuabelasView extends StatelessWidget {
  final String date;
  const AttendancesKelasDuabelasView({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) =>
            AttendanceStudentCubit(usecase: GetAttendanceStudentsUsecase()),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListKelasDuabelasAttendance(date: date),
                    SizedBox(height: height * 0.04),
                    SizedBox(
                      width: double.infinity,
                      height: height * 0.65,
                      child: BlocBuilder<AttendanceStudentCubit,
                          AttendanceStudentState>(
                        builder: (context, state) {
                          if (state is AttendanceStudentLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is AttendanceStudentLoaded) {
                            return state.students.isNotEmpty
                                ? ListView.separated(
                                    itemBuilder: (context, index) {
                                      return CardUserAttendance(
                                        student: state.students[index],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: height * 0.02),
                                    itemCount: state.students.length,
                                  )
                                : const Center(
                                    child: Text('Belum ada data yang terekam'),
                                  );
                          }
                          if (state is AttendanceStudentFailure) {
                            return const Center(
                              child: Text('Something wrongs'),
                            );
                          }
                          return const SplashClassroom();
                        },
                      ),
                    )
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
