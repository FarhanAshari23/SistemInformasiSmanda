import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/bloc/student/get_student_cubit.dart';
import '../../../common/bloc/student/get_student_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_svg.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../ekskul/views/ekskul_view.dart';
import '../../news/views/pengumuman_screen.dart';
import '../../profile/views/student/profile_student_view.dart';
import '../../students/views/siswa_screen.dart';
import '../../teachers/views/teacher_screen.dart';
import '../bloc/bar_navigation_cubit.dart';

class HomeView extends StatelessWidget {
  final int studentId;
  const HomeView({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> iconImage = [
      AppSvg.newsLogo,
      AppSvg.studentLogo,
      AppSvg.teacherLogo,
      AppSvg.ekskulLogo,
      AppSvg.userLogo,
    ];
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BarNavigationCubit(),
        ),
        BlocProvider(
          create: (context) =>
              StudentCubit()..displayStudentById(params: studentId),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return Column(
                  children: [
                    const BasicAppbar(
                      isBackViewed: false,
                      showLogo: true,
                    ),
                    SizedBox(height: height * 0.25),
                    const Text(
                      "Harap tunggu sebentar...",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: height * 0.25),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        4,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CustomInkWell(
                              onTap: () {},
                              defaultColor: AppColors.tertiary,
                              borderRadius: 8,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                width: 70,
                                height: 70,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (state is StudentLoaded) {
                List<Widget> page = [
                  PengumumanScreen(classId: state.student.kelasId ?? 0),
                  const SiswaScreen(),
                  const TeacherScreen(),
                  const EkskulScreen(),
                  ProfileStudentView(studentId: studentId),
                ];
                return Column(
                  children: [
                    BasicAppbar(
                      isBackViewed: false,
                      showLogo: true,
                      student: state.student,
                    ),
                    SizedBox(height: height * 0.0095),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child:
                                page[context.watch<BarNavigationCubit>().state],
                          );
                        },
                      ),
                    ),
                    Builder(builder: (context) {
                      return Container(
                        width: double.infinity,
                        color: AppColors.inversePrimary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            iconImage.length,
                            (index) {
                              bool selected =
                                  context.watch<BarNavigationCubit>().state ==
                                      index;
                              return CustomInkWell(
                                onTap: () {
                                  context
                                      .read<BarNavigationCubit>()
                                      .changeColor(index);
                                },
                                defaultColor: selected
                                    ? AppColors.primary
                                    : AppColors.inversePrimary,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: height * 0.09,
                                  height: height * 0.09,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      iconImage[index],
                                      colorFilter: ColorFilter.mode(
                                        selected
                                            ? AppColors.inversePrimary
                                            : AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }
              if (state is StudentFailure) {
                return Column(
                  children: [
                    const BasicAppbar(
                      isBackViewed: false,
                    ),
                    Text(
                      "Ada masalah: ${state.errorMessage}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
