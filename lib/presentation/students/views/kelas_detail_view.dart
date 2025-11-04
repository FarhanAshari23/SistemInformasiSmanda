import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/get_all_kelas_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';

import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_students_with_kelas.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/students_state.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/stundets_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_user.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/murid_detail.dart';
import 'package:new_sistem_informasi_smanda/common/widget/list_view/list_kelas.dart';

import '../../../common/bloc/kelas/kelas_navigation.dart';
import '../../../common/helper/app_navigation.dart';

class KelasDetailView extends StatelessWidget {
  final int kelas;
  const KelasDetailView({
    super.key,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
        builder: (context, state) {
          if (state is KelasDisplayLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is KelasDisplayLoaded) {
            final kelasSepuluh =
                state.kelas.where((element) => element.degree == 10).toList();
            final kelasSebelas =
                state.kelas.where((element) => element.degree == 11).toList();
            final kelasDuabelas =
                state.kelas.where((element) => element.degree == 12).toList();
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      StudentsDisplayCubit(usecase: GetStudentsWithKelas())
                        ..displayStudentsInit(
                          params: kelas == 10
                              ? kelasSepuluh[0].kelas
                              : kelas == 11
                                  ? kelasSebelas[0].kelas
                                  : kelasDuabelas[0].kelas,
                        ),
                ),
                BlocProvider(
                  create: (context) => KelasNavigationCubit(),
                ),
              ],
              child: SafeArea(
                child: Column(
                  children: [
                    const BasicAppbar(
                      isBackViewed: true,
                      isProfileViewed: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListKelas(kelas: kelas),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<StudentsDisplayCubit,
                          StudentsDisplayState>(
                        builder: (context, state) {
                          if (state is StudentsDisplayLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is StudentsDisplayLoaded) {
                            return state.students.isNotEmpty
                                ? ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    itemBuilder: (context, index) {
                                      return CardUser(
                                        onTap: () => AppNavigator.push(
                                          context,
                                          MuridDetail(
                                            user: state.students[index],
                                          ),
                                        ),
                                        name: state.students[index].nama!,
                                        nisn: state.students[index].nisn!,
                                        agama: state.students[index].agama!,
                                        gender: state.students[index].gender!,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: height * 0.02),
                                    itemCount: state.students.length,
                                  )
                                : const Center(
                                    child: Text('Belum ada data'),
                                  );
                          }
                          if (state is StudentsDisplayFailure) {
                            return const Center(
                              child: Text('Something wrongs'),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
