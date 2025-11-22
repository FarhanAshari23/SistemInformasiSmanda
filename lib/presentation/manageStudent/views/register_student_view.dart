import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/delete_all_student_account_usecase.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/dialog/choose_dialog.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/students/accept_student_register_usecase.dart';
import '../../../domain/usecases/students/delete_student.dart';
import '../../../domain/usecases/students/update_all_student_account_usecase.dart';
import '../../../service_locator.dart';
import '../bloc/get_student_registration_cubit.dart';
import '../bloc/get_student_registration_state.dart';
import '../widgets/button_all.dart';
import 'register_account_detail_view.dart';

class RegisterStudentView extends StatelessWidget {
  const RegisterStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetStudentRegistrationCubit()..displayStudentRegistration(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: SafeArea(
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                context
                    .read<GetStudentRegistrationCubit>()
                    .displayStudentRegistration();
                var snackbar = const SnackBar(
                  content: Text("Data Berhasil Diubah"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                Navigator.pop(context);
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Pilih akun yang ingin konfirmasi registrasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                BlocBuilder<GetStudentRegistrationCubit,
                    StudentsRegistrationState>(
                  builder: (context, state) {
                    if (state is StudentsRegistrationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is StudentsRegistrationLoaded) {
                      if (state.students.isEmpty) {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<GetStudentRegistrationCubit>()
                                  .displayStudentRegistration();
                            },
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                SizedBox(height: height * 0.15),
                                Center(
                                  child: Image.asset(
                                    AppImages.emptyRegistrationChara,
                                    width: height * 0.2,
                                    height: height * 0.2,
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'Tidak ada akun yang harus di konfirmasi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<GetStudentRegistrationCubit>()
                                .displayStudentRegistration();
                          },
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonAll(
                                          title: 'Setujui Semua',
                                          onTap: () {
                                            final outerContext = context;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BlocProvider.value(
                                                  value: outerContext
                                                      .read<ButtonStateCubit>(),
                                                  child: ChooseDialog(
                                                    height: height,
                                                    title:
                                                        'Apakah Anda Yakin Ingin Menyetujui seluruh data siswa?',
                                                    onTap: () {
                                                      outerContext
                                                          .read<
                                                              ButtonStateCubit>()
                                                          .execute(
                                                            usecase:
                                                                UpdateAllStudentAccountUsecase(),
                                                          );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        ButtonAll(
                                          title: 'Hapus Semua',
                                          onTap: () {
                                            final outerContext = context;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return BlocProvider.value(
                                                  value: outerContext
                                                      .read<ButtonStateCubit>(),
                                                  child: ChooseDialog(
                                                    height: height,
                                                    title:
                                                        'Apakah Anda Yakin Ingin Menghapus seluruh data siswa?',
                                                    onTap: () {
                                                      outerContext
                                                          .read<
                                                              ButtonStateCubit>()
                                                          .execute(
                                                            usecase:
                                                                DeleteAllStudentAccountUsecase(),
                                                          );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                final dataIndex = index - 1;
                                final students = state.students[dataIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: CustomInkWell(
                                    borderRadius: 16,
                                    defaultColor: AppColors.secondary,
                                    onTap: () => AppNavigator.push(
                                      context,
                                      RegisterAccountDetailView(
                                        user: students,
                                      ),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                students.nama ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.inversePrimary,
                                                ),
                                              ),
                                              Text(
                                                students.nisn ?? '',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.inversePrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              CustomInkWell(
                                                borderRadius: 999,
                                                defaultColor: AppColors.primary,
                                                onTap: () {
                                                  context
                                                      .read<ButtonStateCubit>()
                                                      .execute(
                                                        usecase:
                                                            UpdateStudentRegisterUsecase(),
                                                        params: students,
                                                      );
                                                },
                                                child: const SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              CustomInkWell(
                                                borderRadius: 999,
                                                defaultColor: Colors.red,
                                                onTap: () async {
                                                  var result = await sl<
                                                          DeleteStudentUsecase>()
                                                      .call(params: students);
                                                  result.fold(
                                                    (error) {
                                                      var snackbar = SnackBar(
                                                        content: Text(
                                                            "Gagal Mengubah Data: $error"),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackbar);
                                                    },
                                                    (r) {
                                                      context
                                                          .read<
                                                              GetStudentRegistrationCubit>()
                                                          .displayStudentRegistration();
                                                      var snackbar =
                                                          const SnackBar(
                                                        content: Text(
                                                            "Akun berhasil dihapus"),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackbar);
                                                    },
                                                  );
                                                },
                                                child: const SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: height * 0.01),
                            itemCount: state.students.length + 1,
                          ),
                        ),
                      );
                    }
                    if (state is StudentsRegistrationFailure) {
                      return Text(state.toString());
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
