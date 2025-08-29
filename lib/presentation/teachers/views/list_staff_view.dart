import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_staff.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/get_tendik_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/staff_detail.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/teacher/teacher_state.dart';

class ListStaffView extends StatelessWidget {
  const ListStaffView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => GetTendikCubit()..displayTendik(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      "Daftar Staff SMAN 2 METRO",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    BlocBuilder<GetTendikCubit, TeacherState>(
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
                                return CardStaff(
                                  title: state.teacher[index].nama,
                                  content: state.teacher[index].mengajar,
                                  page: StaffDetail(
                                    teachers: state.teacher[index],
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
