import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/kelas/students_state.dart';
import '../../bloc/kelas/stundets_cubit.dart';
import '../card/card_user.dart';
import '../landing/not_found.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../domain/usecases/students/get_student_by_name.dart';
import 'search_student_appbar.dart';

class SearchStudentsView extends StatelessWidget {
  const SearchStudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                              width: width * 0.9,
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
        return CardUser(
          onTap: () => Navigator.pop(context, students[index].nama),
          name: students[index].nama!,
          nisn: students[index].nisn!,
          agama: students[index].agama!,
          gender: students[index].gender!,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemCount: students.length,
    );
  }
}
