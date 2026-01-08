import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_guru.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/teacher/teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../home/bloc/bar_navigation_cubit.dart';

class TeacherView extends StatelessWidget {
  const TeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TeacherCubit()..displayTeacher(),
          ),
          BlocProvider(
            create: (context) => BarNavigationCubit(),
          ),
        ],
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
              SizedBox(height: height * 0.02),
              Builder(builder: (context) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      3,
                      (index) {
                        List<String> title = [
                          "Semua",
                          "Wali Kelas",
                          "Jabatan Tambahan",
                        ];
                        return CustomInkWell(
                          onTap: () {
                            context
                                .read<BarNavigationCubit>()
                                .changeColor(index);
                          },
                          defaultColor:
                              context.watch<BarNavigationCubit>().state == index
                                  ? AppColors.primary
                                  : AppColors.tertiary,
                          left: index == 0 ? 8 : 0,
                          right: index == 2 ? 8 : 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              title[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ));
              }),
              SizedBox(height: height * 0.02),
              BlocBuilder<TeacherCubit, TeacherState>(
                builder: (context, state) {
                  if (state is TeacherLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is TeacherLoaded) {
                    final tabIndex = context.watch<BarNavigationCubit>().state;

                    final all = state.teacher;
                    final wali = all.where((e) => e.waliKelas != '-').toList();
                    final jabatan = all.where((e) => e.jabatan != '-').toList();

                    final selected = [all, wali, jabatan][tabIndex]
                        .where((e) => e.nama != "Seluruh Siswa")
                        .toList();
                    if (selected.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: height * 0.05),
                          Image.asset(
                            AppImages.notfound,
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: height * 0.01),
                          const Text(
                            "Data guru tidak ditemukan",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          )
                        ],
                      );
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          itemCount: selected.length,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                  teachers: selected[index],
                                ),
                              ),
                              borderRadius: 8,
                              defaultColor: AppColors.secondary,
                              child: CardGuru(
                                forceRefresh: false,
                                teacher: selected[index],
                              ),
                            );
                          },
                        ),
                      );
                    }
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
