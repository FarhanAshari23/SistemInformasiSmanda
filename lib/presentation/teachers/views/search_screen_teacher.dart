import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/not_found.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_teacher_by_name.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/get_teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/get_teacher_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/widgets/search_teacher_appbar.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/card/card_guru.dart';
import '../../../core/configs/theme/app_colors.dart';

class SearchScreenTeacher extends StatelessWidget {
  const SearchScreenTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => GetTeacherCubit(usecase: GetTeacherByNameUsecase()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              SearchTeacherAppbar(),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<GetTeacherCubit, GetTeacherState>(
                  builder: (context, state) {
                    if (state is GetTeacherLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetTeacherLoaded) {
                      return state.teachers.isEmpty
                          ? const NotFound(objek: 'Guru')
                          : SizedBox(
                              width: width * 0.9,
                              height: height * 0.75,
                              child: _teachers(state.teachers, height),
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

  Widget _teachers(List<TeacherEntity> teachers, double height) {
    return GridView.builder(
      itemCount: teachers.length,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        mainAxisExtent: height * 0.25,
      ),
      itemBuilder: (BuildContext context, int index) {
        return CustomInkWell(
          onTap: () => AppNavigator.push(
            context,
            TeacherDetail(
              teachers: teachers[index],
            ),
          ),
          borderRadius: 8,
          defaultColor: AppColors.secondary,
          child: CardGuru(
            gender: teachers[index].gender ?? 0,
            nip: teachers[index].nip,
            title: teachers[index].nama,
          ),
        );
      },
    );
  }
}
