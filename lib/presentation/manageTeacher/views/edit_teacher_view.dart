import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/widgets/card_edit_teacher.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../home/bloc/teacher_state.dart';

class EditTeacherView extends StatelessWidget {
  const EditTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TeacherCubit()..displayTeacher(),
          child: Column(
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
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
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return CardEditTeacher(
                                    teacher: state.teacher[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: height * 0.02),
                              itemCount: state.teacher.length,
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
