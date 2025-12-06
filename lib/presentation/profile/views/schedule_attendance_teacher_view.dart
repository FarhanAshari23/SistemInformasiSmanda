import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../bloc/get_teacher_attendance_cubit.dart';
import '../bloc/get_teacher_attendance_state.dart';

class ScheduleAttendanceTeacherView extends StatelessWidget {
  final TeacherEntity teacher;
  const ScheduleAttendanceTeacherView({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            GetTeacherAttendanceCubit()..getAttendanceTeacher(teacher),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
                isLogout: false,
              ),
              BlocBuilder<GetTeacherAttendanceCubit, GetTeacherAttendanceState>(
                builder: (context, state) {
                  if (state is GetTeacherAttendanceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetTeacherAttendanceLoaded) {
                    return Text(state.attendances[0].timestamp.toString());
                  }
                  if (state is GetTeacherAttendanceFailure) {
                    return Text(state.errorMessage);
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
