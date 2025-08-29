import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/card_guru.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';

class ListTeacherView extends StatelessWidget {
  const ListTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => TeacherCubit()..displayTeacher(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      "Daftar Guru SMAN 2 METRO",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    BlocBuilder<TeacherCubit, TeacherState>(
                      builder: (context, state) {
                        if (state is TeacherLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is TeacherLoaded) {
                          return SizedBox(
                            width: double.infinity,
                            height: height * 0.7,
                            child: GridView.builder(
                              itemCount: state.teacher.length,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                mainAxisExtent: height * 0.25,
                              ),
                              itemBuilder: (context, index) {
                                return CustomInkWell(
                                  onTap: () => Navigator.pop(
                                    context,
                                    state.teacher[index].nama,
                                  ),
                                  borderRadius: 8,
                                  defaultColor: AppColors.secondary,
                                  child: CardGuru(
                                    nip: state.teacher[index].nip,
                                    title: state.teacher[index].nama,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
