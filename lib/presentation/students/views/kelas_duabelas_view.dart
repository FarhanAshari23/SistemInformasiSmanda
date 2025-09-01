import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/murid_detail.dart';
import 'package:new_sistem_informasi_smanda/common/widget/list_view/list_kelas_duabelas.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../domain/usecases/students/get_students_with_kelas.dart';
import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/card/card_user.dart';

class KelasDuabelasView extends StatelessWidget {
  const KelasDuabelasView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                StudentsDisplayCubit(usecase: GetStudentsWithKelas())
                  ..displayStudentsInit(params: '12 1'),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: true),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const ListKelasDuabelas(),
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
                                      return CustomInkWell(
                                        child: CardUser(
                                          onTap: () => AppNavigator.push(
                                            context,
                                            MuridDetail(
                                              user: state.students[index],
                                            ),
                                          ),
                                          name: state.students[index].nama!,
                                          nisn: state.students[index].nisn!,
                                          gender: state.students[index].gender!,
                                        ),
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
