import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/card/card_guru.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/landing/not_found.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/teacher/get_teacher_by_name.dart';
import '../../teachers/widgets/search_teacher_appbar.dart';
import '../bloc/select_teacher_name_cubit.dart';
import '../bloc/select_teacher_name_state.dart';

class SelectTeacherView extends StatelessWidget {
  const SelectTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) =>
          GetTeacherNameCubit(usecase: GetTeacherByNameUsecase()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              SearchTeacherAppbar(isTeacherGolang: true),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<GetTeacherNameCubit, GetTeacherNameState>(
                  builder: (context, state) {
                    if (state is GetTeacherNameLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetTeacherNameLoaded) {
                      return state.teachers.isEmpty
                          ? const NotFound(objek: 'Guru')
                          : SizedBox(
                              width: width * 0.9,
                              height: height * 0.75,
                              child: _teachers(state.teachers, height),
                            );
                    }
                    if (state is GetTeacherNameFailure) {
                      return Text(state.errorMessage);
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
          onTap: () => Navigator.pop(context, teachers[index]),
          borderRadius: 8,
          defaultColor: AppColors.secondary,
          child: CardGuru(
            teacher: teachers[index],
          ),
        );
      },
    );
  }
}
