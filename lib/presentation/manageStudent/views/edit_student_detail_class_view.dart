import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/list_view/list_kelas_duabelas.dart';
import 'package:new_sistem_informasi_smanda/common/widget/list_view/list_kelas_sebelas.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/list_view/list_kelas_sepuluh.dart';
import '../../../domain/usecases/students/get_students_with_kelas.dart';
import '../widgets/card_edit_user.dart';

class EditStudentDetailClassView extends StatelessWidget {
  final int kelas;
  const EditStudentDetailClassView({
    super.key,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            return BlocProvider(
              create: (context) =>
                  StudentsDisplayCubit(usecase: GetStudentsWithKelas())
                    ..displayStudentsInit(
                      params: kelas == 10
                          ? kelasSepuluh[0].kelas
                          : kelas == 11
                              ? kelasSebelas[0].kelas
                              : kelasDuabelas[0].kelas,
                    ),
              child: SafeArea(
                child: Column(
                  children: [
                    const BasicAppbar(
                        isBackViewed: true, isProfileViewed: false),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          kelas == 10
                              ? const ListKelasSepuluh()
                              : kelas == 11
                                  ? const ListKelasSebelas()
                                  : const ListKelasDuabelas(),
                          SizedBox(height: height * 0.04),
                          SizedBox(
                            width: double.infinity,
                            height: height * 0.65,
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
                                          itemBuilder: (context, index) {
                                            return CardEditUser(
                                              student: state.students[index],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              SizedBox(height: height * 0.02),
                                          itemCount: state.students.length,
                                        )
                                      : const Center(
                                          child: Text('Belum ada kelas'),
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
                          )
                        ],
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
