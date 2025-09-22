import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/delete_student_by_class.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/kelas/kelas_navigation.dart';
import '../../../common/bloc/kelas/students_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/list_view/list_kelas.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../domain/usecases/students/get_students_with_kelas.dart';
import '../../../service_locator.dart';
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
    double width = MediaQuery.of(context).size.width;

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
                      isProfileViewed: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: ListKelas(kelas: kelas),
                    ),
                    BlocBuilder<StudentsDisplayCubit, StudentsDisplayState>(
                      builder: (context, state) {
                        if (state is StudentsDisplayLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is StudentsDisplayLoaded) {
                          return state.students.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    itemBuilder: (context, index) {
                                      final selectedIndex = context
                                          .read<KelasNavigationCubit>()
                                          .state;
                                      final String currentClass = kelas == 10
                                          ? kelasSepuluh[selectedIndex].kelas
                                          : kelas == 11
                                              ? kelasSebelas[selectedIndex]
                                                  .kelas
                                              : kelasDuabelas[selectedIndex]
                                                  .kelas;
                                      if (index == 0) {
                                        return CustomInkWell(
                                          borderRadius: 16,
                                          defaultColor: AppColors.primary,
                                          onTap: () {
                                            final outerContext = context;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor:
                                                      AppColors.inversePrimary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  insetPadding:
                                                      EdgeInsets.symmetric(
                                                    vertical: height * 0.2,
                                                    horizontal: 16,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: width * 0.6,
                                                        height: height * 0.3,
                                                        decoration:
                                                            const BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                                AppImages
                                                                    .splashDelete),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Apakah anda yakin ingin menghapus seluruh data siswa dari kelas $currentClass?',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.02),
                                                      BasicButton(
                                                        onPressed: () async {
                                                          var delete = await sl<
                                                                  DeleteStudentByClassUsecase>()
                                                              .call(
                                                                  params:
                                                                      currentClass);
                                                          return delete.fold(
                                                            (error) {
                                                              var snackbar =
                                                                  SnackBar(
                                                                content: Text(
                                                                    "Gagal Menghapus Murid, Coba Lagi: $error"),
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackbar);
                                                            },
                                                            (r) {
                                                              Navigator.pop(
                                                                  context);
                                                              var snackbar =
                                                                  const SnackBar(
                                                                content: Text(
                                                                    "Data Berhasil Dihapus"),
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackbar);
                                                              outerContext
                                                                  .read<
                                                                      StudentsDisplayCubit>()
                                                                  .displayStudents(
                                                                      params:
                                                                          currentClass);
                                                            },
                                                          );
                                                        },
                                                        title: 'Hapus',
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Hapus Semua',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        final newIndex = index - 1;
                                        return CardEditUser(
                                          student: state.students[newIndex],
                                        );
                                      }
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: height * 0.02),
                                    itemCount: state.students.length + 1,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: height * 0.2),
                                  child: const Center(
                                    child: Text('Belum ada kelas'),
                                  ),
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
