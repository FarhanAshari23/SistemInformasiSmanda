import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/students_state.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/stundets_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/not_found.dart';
import 'package:new_sistem_informasi_smanda/common/widget/searchbar/search_student_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_user.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_student_by_name.dart';

import '../../../common/helper/app_navigation.dart';
import 'murid_detail.dart';

class SearchScreenStudent extends StatelessWidget {
  const SearchScreenStudent({super.key});

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
          onTap: () => AppNavigator.push(
            context,
            MuridDetail(
              user: students[index],
            ),
          ),
          agama: students[index].agama!,
          name: students[index].nama!,
          nisn: students[index].nisn!,
          gender: students[index].gender!,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: height * 0.02),
      itemCount: students.length,
    );
  }
}
