import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/card/card_guru.dart';
import '../../../common/widget/card/card_guru_complete.dart';
import '../../../common/widget/card/card_organization.dart';
import '../../../common/widget/detail/teacher_detail.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../blocs/teacher_navigation_cubit.dart';
import 'search_screen_teacher.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => TeacherCubit()..displayTeacher(),
      child: BlocBuilder<TeacherCubit, TeacherState>(
        builder: (context, state) {
          if (state is TeacherLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TeacherListLoaded) {
            List<List<TeacherEntity>> teachersEntity = [
              state.teachers,
              state.teachers.where((e) => e.waliKelas!.isNotEmpty).toList(),
              state.teachers.where((e) {
                final tasks = e.tasksName ?? [];

                return tasks.isNotEmpty &&
                    !tasks.any((t) => t.contains("Kepala Sekolah")) &&
                    !tasks.any((t) => t.contains("Wakil Kepala Sekolah"));
              }).toList(),
            ];
            TeacherEntity kepsek = state.teachers.firstWhere(
              (teacher) =>
                  teacher.tasksName?.contains("Kepala Sekolah") ?? false,
            );
            List<TeacherEntity> wakas = state.teachers.where((data) {
              return data.tasksName?.any((task) => task
                      .toLowerCase()
                      .contains("wakil kepala sekolah".toLowerCase())) ??
                  false;
            }).toList();
            final tabIndex = context.watch<TeacherNavigationCubit>().state;
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Kepala Sekolah",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CardOrganization(
                  teacher: kepsek,
                  isKepsek: true,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Wakil Kepala Sekolah",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final waka = wakas[index];
                    return CardOrganization(teacher: waka);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: wakas.length,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Daftar Guru",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (index) {
                          List<String> title = [
                            "Semua",
                            "Wali Kelas",
                            "Tugas Tambahan",
                          ];
                          return CustomInkWell(
                            onTap: () {
                              context
                                  .read<TeacherNavigationCubit>()
                                  .changeColor(index);
                            },
                            defaultColor: tabIndex == index
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
                      ),
                    ),
                    IconButton(
                      onPressed: () => AppNavigator.push(
                        context,
                        const SearchScreenTeacher(),
                      ),
                      highlightColor: AppColors.inversePrimary,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary,
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                tabIndex == 0
                    ? GridView.builder(
                        itemCount: teachersEntity[tabIndex].length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 48,
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
                                teacherId: teachersEntity[tabIndex][index].id!,
                              ),
                            ),
                            borderRadius: 8,
                            defaultColor: AppColors.secondary,
                            child: CardGuru(
                              forceRefresh: false,
                              teacher: teachersEntity[tabIndex][index],
                            ),
                          );
                        },
                      )
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CardGuruComplete(
                            teacher: teachersEntity[tabIndex][index],
                            desc: tabIndex == 1
                                ? "Kelas: ${teachersEntity[tabIndex][index].waliKelas}"
                                : "Tugas: ${teachersEntity[tabIndex][index].tasksName!.join(", ")}",
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemCount: teachersEntity[tabIndex].length,
                      ),
              ],
            );
          }
          if (state is TeacherFailure) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }
}
