import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/attendance/get_attendance_name_usecase.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/search_student_attendance_appbar.dart';

import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/landing/not_found.dart';
import '../../../domain/entities/auth/user.dart';
import '../../manageStudent/views/search_student_edit.dart';
import '../../manageStudent/widgets/card_edit_user.dart';

class SearchStudentAttendance extends StatelessWidget {
  final String date;
  const SearchStudentAttendance({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) =>
          StudentsDisplayCubit(usecase: GetAttendanceNameUsecase()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              SearchStudentAttendanceAppbar(date: date),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<StudentsDisplayCubit, StudentsDisplayState>(
                  builder: (context, state) {
                    if (state is StudentsDisplayLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is StudentsDisplayLoaded) {
                      return state.students.isEmpty
                          ? const NotFound(objek: 'Murid')
                          : SizedBox(
                              width: double.infinity,
                              height: height * 0.75,
                              child: _students(state.students, height),
                            );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _students(List<UserEntity> students, double height) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return CardEditUser(
          student: students[0],
          backPage: const SearchStudentEdit(),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemCount: students.length,
    );
  }
}
