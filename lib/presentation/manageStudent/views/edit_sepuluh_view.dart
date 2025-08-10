import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/list_view/list_kelas_sepuluh.dart';
import '../../../domain/usecases/students/get_students_with_kelas.dart';
import '../../students/bloc/sepuluh_init_cubit.dart';
import '../widgets/card_edit_user.dart';

class EditSepuluhView extends StatelessWidget {
  const EditSepuluhView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                StudentsDisplayCubit(usecase: GetStudentsWithKelas()),
          ),
          BlocProvider(
            create: (context) => SepuluhInitCubit()..displaySepuluhInit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const ListKelasSepuluh(),
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
                                        backPage: const EditSepuluhView(),
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
                          return BlocBuilder<SepuluhInitCubit,
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
                                            backPage: const EditSepuluhView(),
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
                              return Container();
                            },
                          );
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
