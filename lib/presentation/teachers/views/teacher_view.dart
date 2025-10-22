import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_guru.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/teacher/teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/teacher/teacher_state.dart';

class TeacherView extends StatelessWidget {
  const TeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => TeacherCubit()..displayTeacher(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: true),
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
                    state.teacher.removeWhere(
                        (element) => element.nama == "Seluruh Siswa");
                    return Expanded(
                      child: GridView.builder(
                        itemCount: state.teacher.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: height * 0.25,
                        ),
                        itemBuilder: (context, index) {
                          return CustomInkWell(
                            onTap: () => AppNavigator.push(
                              context,
                              TeacherDetail(
                                teachers: state.teacher[index],
                              ),
                            ),
                            borderRadius: 8,
                            defaultColor: AppColors.secondary,
                            child: CardGuru(
                              nip: state.teacher[index].nip,
                              title: state.teacher[index].nama,
                              gender: state.teacher[index].gender ?? 0,
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
        ),
      ),
    );
  }
}
