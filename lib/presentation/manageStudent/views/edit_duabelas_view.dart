import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/list_view/list_kelas_duabelas.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/delete_student_by_class.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/edit_student_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/bloc/duabelas_init_cubit.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/students/get_students_with_kelas.dart';
import '../widgets/card_edit_user.dart';

class EditDuabelasView extends StatelessWidget {
  const EditDuabelasView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                StudentsDisplayCubit(usecase: GetStudentsWithKelas()),
          ),
          BlocProvider(
            create: (context) => DuabelasInitCubit()..displayDuabelasInit(),
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
                                      if (index == 0) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.5,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        AppColors.secondary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    child: SizedBox(
                                                      height: height * 0.565,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 12,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              AppImages
                                                                  .splashDelete,
                                                            ),
                                                            SizedBox(
                                                                height: height *
                                                                    0.02),
                                                            Text(
                                                              'Apakah Anda Yakin Ingin Menghapus Seluruh Data Kelas ${state.students[0].kelas}?',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: AppColors
                                                                    .inversePrimary,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                                height: height *
                                                                    0.02),
                                                            BlocProvider(
                                                              create: (context) =>
                                                                  ButtonStateCubit(),
                                                              child: BlocListener<
                                                                  ButtonStateCubit,
                                                                  ButtonState>(
                                                                listener:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is ButtonSuccessState) {
                                                                    AppNavigator.pushReplacement(
                                                                        context,
                                                                        const EditStudentView());
                                                                  }
                                                                  if (state
                                                                      is ButtonFailureState) {
                                                                    var snackbar =
                                                                        SnackBar(
                                                                      content: Text(
                                                                          state
                                                                              .errorMessage),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                    );
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            snackbar);
                                                                  }
                                                                },
                                                                child: Builder(
                                                                    builder:
                                                                        (context) {
                                                                  return BasicButton(
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .read<
                                                                              ButtonStateCubit>()
                                                                          .execute(
                                                                            usecase:
                                                                                DeleteStudentByClassUsecase(),
                                                                            params:
                                                                                state.students[0].kelas,
                                                                          );
                                                                    },
                                                                    title:
                                                                        'Hapus',
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: height * 0.075,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: AppColors.secondary,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Hapus Semua',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors
                                                        .inversePrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return CardEditUser(
                                          student: state.students[index - 1],
                                          backPage: const EditDuabelasView(),
                                        );
                                      }
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: height * 0.02),
                                    itemCount: state.students.length + 1,
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
                          return BlocBuilder<DuabelasInitCubit,
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
                                          if (index == 0) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                right: width * 0.5,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            AppColors.secondary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: SizedBox(
                                                          height:
                                                              height * 0.565,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Image.asset(
                                                                  AppImages
                                                                      .splashDelete,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.02),
                                                                Text(
                                                                  'Apakah Anda Yakin Ingin Menghapus Seluruh Data Kelas ${state.students[0].kelas}?',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: AppColors
                                                                        .inversePrimary,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.02),
                                                                BlocProvider(
                                                                  create: (context) =>
                                                                      ButtonStateCubit(),
                                                                  child: BlocListener<
                                                                      ButtonStateCubit,
                                                                      ButtonState>(
                                                                    listener:
                                                                        (context,
                                                                            state) {
                                                                      if (state
                                                                          is ButtonSuccessState) {
                                                                        AppNavigator.pushReplacement(
                                                                            context,
                                                                            const EditStudentView());
                                                                      }
                                                                      if (state
                                                                          is ButtonFailureState) {
                                                                        var snackbar =
                                                                            SnackBar(
                                                                          content:
                                                                              Text(state.errorMessage),
                                                                          behavior:
                                                                              SnackBarBehavior.floating,
                                                                        );
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(snackbar);
                                                                      }
                                                                    },
                                                                    child: Builder(
                                                                        builder:
                                                                            (context) {
                                                                      return BasicButton(
                                                                        onPressed:
                                                                            () {
                                                                          context
                                                                              .read<ButtonStateCubit>()
                                                                              .execute(
                                                                                usecase: DeleteStudentByClassUsecase(),
                                                                                params: state.students[0].kelas,
                                                                              );
                                                                        },
                                                                        title:
                                                                            'Hapus',
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: height * 0.075,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: AppColors.secondary,
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      'Hapus Semua',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: AppColors
                                                            .inversePrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return CardEditUser(
                                              student:
                                                  state.students[index - 1],
                                              backPage:
                                                  const EditDuabelasView(),
                                            );
                                          }
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: height * 0.02),
                                        itemCount: state.students.length + 1,
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
