import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/landing/not_found.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/usecases/students/get_student_by_name.dart';
import '../../../common/widget/searchbar/search_student_appbar.dart';
import '../widgets/card_edit_user.dart';

class SearchStudentEdit extends StatelessWidget {
  const SearchStudentEdit({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) =>
          StudentsDisplayCubit(usecase: GetStudentByNameUsecase()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              const SearchStudentAppBar(),
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

  Widget _students(List<StudentEntity> students, double height) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return CardEditUser(
          student: students[index],
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemCount: students.length,
    );
  }
}
