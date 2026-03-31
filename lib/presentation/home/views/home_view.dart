import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../ekskul/views/ekskul_view.dart';
import '../../news/views/pengumuman_screen.dart';
import '../../students/views/siswa_screen.dart';
import '../../teachers/blocs/teacher_navigation_cubit.dart';
import '../../teachers/views/teacher_screen.dart';
import '../bloc/bar_navigation_cubit.dart';

class HomeView extends StatelessWidget {
  final StudentEntity student;
  const HomeView({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> iconImage = [
      AppImages.information,
      AppImages.students,
      AppImages.teacher,
      AppImages.eskul,
    ];
    List<String> title = [
      'HALAMAN PENGUMUMAN',
      'HALAMAN KELAS',
      'HALAMAN TENDIK',
      'HALAMAN EKSKUL',
    ];
    List<Widget> page = [
      const PengumumanScreen(),
      const SiswaScreen(),
      const TeacherScreen(),
      const EkskulScreen(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => BarNavigationCubit(),
          ),
          BlocProvider(
            create: (context) => TeacherNavigationCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              BasicAppbar(
                isBackViewed: false,
                student: student,
              ),
              SizedBox(height: height * 0.0095),
              Builder(
                builder: (context) {
                  return Text(
                    title[context.watch<BarNavigationCubit>().state],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child:
                              page[context.watch<BarNavigationCubit>().state],
                        );
                      },
                    ),
                    SizedBox(height: height * 0.01),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Builder(builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              4,
                              (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CustomInkWell(
                                    onTap: () {
                                      context
                                          .read<BarNavigationCubit>()
                                          .changeColor(index);
                                    },
                                    defaultColor: context
                                                .watch<BarNavigationCubit>()
                                                .state ==
                                            index
                                        ? AppColors.primary
                                        : AppColors.tertiary,
                                    borderRadius: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                      width: 70,
                                      height: 70,
                                      child: Center(
                                        child: Image.asset(
                                          iconImage[index],
                                          width: 50,
                                          height: 50,
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
