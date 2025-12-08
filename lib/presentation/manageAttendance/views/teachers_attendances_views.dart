import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../bloc/attendance_teacher_cubit.dart';
import '../bloc/attendance_teacher_state.dart';
import '../widgets/card_teacher_attendance.dart';

class TeachersAttendancesViews extends StatelessWidget {
  final bool isAttendace;
  const TeachersAttendancesViews({
    super.key,
    required this.isAttendace,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            SizedBox(height: height * 0.04),
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
                            ),
                            itemBuilder: (context, index) {
                              return CardTeacherAttendance(
                                teacher: state.teachers[index],
                                isAttendance: isAttendace,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: height * 0.02),
                            itemCount: state.teachers.length,
                          ),
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
}
