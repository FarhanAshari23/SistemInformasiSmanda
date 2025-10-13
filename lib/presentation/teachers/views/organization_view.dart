import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/loading/card_guru_loading.dart';
import 'package:new_sistem_informasi_smanda/common/widget/loading/card_kepsek_loading.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/kepsek_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/kepsek_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/waka_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/waka_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';

import '../../../common/widget/card/card_staff.dart';
import '../widgets/card_kepala_sekolah.dart';

class OrganizationView extends StatelessWidget {
  const OrganizationView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => KepalaSekolahCubit()..displayKepalaSekolah(),
        ),
        BlocProvider(
          create: (context) => WakaCubit()..displayWaka(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: true),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Kepala Sekolah:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              BlocBuilder<KepalaSekolahCubit, KepalaSekolahState>(
                builder: (context, state) {
                  if (state is KepalaSekolahLoading) {
                    return const CardKepsekLoading();
                  }
                  if (state is KepalaSekolahLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CardKepalaSekolah(
                        nisn: state.teacher[0].nip,
                        title: state.teacher[0].nama,
                        gender: state.teacher[0].gender ?? 0,
                        page: TeacherDetail(teachers: state.teacher[0]),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: height * 0.02),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Wakil Kepala Sekolah:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: BlocBuilder<WakaCubit, WakaState>(
                  builder: (context, state) {
                    if (state is WakaLoading) {
                      return GridView.builder(
                        itemCount: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: height * 0.25,
                        ),
                        itemBuilder: (context, index) {
                          return const CardGuruLoading();
                        },
                      );
                    }
                    if (state is WakaLoaded) {
                      return GridView.builder(
                        itemCount: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: height * 0.25,
                        ),
                        itemBuilder: (context, index) {
                          String jabatan = state.teacher[index].jabatan;
                          List<String> kata = jabatan.split(",");
                          String mainJabatan = kata.firstWhere(
                            (e) => e
                                .trim()
                                .toLowerCase()
                                .contains("wakil kepala sekolah".toLowerCase()),
                            orElse: () => "",
                          );
                          return CardStaff(
                            title: state.teacher[index].nama,
                            content: mainJabatan,
                            page: TeacherDetail(
                              teachers: state.teacher[index],
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
