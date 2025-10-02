import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/bar_navigation_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/screens/ekskul_screen.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/screens/pengumuman_screen.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/screens/siswa_screen.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/screens/teacher_screen.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
      BlocProvider(
        create: (context) => GetAllKelasCubit()..displayAll(),
        child: const SiswaScreen(),
      ),
      const TeacherScreen(),
      const EkskulScreen(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => BarNavigationCubit(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(
                isBackViewed: false,
                isProfileViewed: true,
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
              Builder(
                builder: (context) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: page[context.watch<BarNavigationCubit>().state],
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.01),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      4,
                      (index) {
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
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Image.asset(
                                iconImage[index],
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
