import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/accept_student_register_usecase.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/delete_student.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/update_all_student_account_usecase.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_state.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';

class RegisterStudentView extends StatelessWidget {
  const RegisterStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) =>
            GetStudentRegistrationCubit()..displayStudentRegistration(),
        child: SafeArea(
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
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                top: 16,
                                bottom: 8,
                                right: height * 0.25,
                              ),
                              child: CustomInkWell(
                                borderRadius: 12,
                                defaultColor: AppColors.inversePrimary,
                                onTap: () {
                                  final parentContext = context;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: AppColors.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: height * 0.02),
                                            const Text(
                                              'Apakah Anda Yakin Ingin Menyetujui seluruh data siswa?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.inversePrimary,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: height * 0.02),
                                            BlocProvider(
                                              create: (context) =>
                                                  ButtonStateCubit(),
                                              child: BlocListener<
                                                  ButtonStateCubit,
                                                  ButtonState>(
                                                listener: (context, state) {
                                                  if (state
                                                      is ButtonSuccessState) {}
                                                  if (state
                                                      is ButtonFailureState) {
                                                    var snackbar = SnackBar(
                                                      content: Text(
                                                          state.errorMessage),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackbar);
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Builder(
                                                      builder: (context) {
                                                        return Expanded(
                                                          child: BasicButton(
                                                            onPressed:
                                                                () async {
                                                              var result = await sl<
                                                                      UpdateAllStudentAccountUsecase>()
                                                                  .call();
                                                              result.fold(
                                                                (error) {
                                                                  var snackbar =
                                                                      SnackBar(
                                                                    content: Text(
                                                                        "Gagal Mengubah Data: $error"),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackbar);
                                                                },
                                                                (r) {
                                                                  parentContext
                                                                      .read<
                                                                          GetStudentRegistrationCubit>()
                                                                      .displayStudentRegistration();
                                                                  var snackbar =
                                                                      const SnackBar(
                                                                    content: Text(
                                                                        "Data Berhasil Diubah"),
                                                                  );
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackbar);

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              );
                                                            },
                                                            title: 'Setuju',
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: BasicButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        title: "Batal",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Setujui semua',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final dataIndex = index - 1;
                            final students = state.students[dataIndex];
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                                          color: AppColors.inversePrimary,
                                        ),
                                      ),
                                      Text(
                                        students.nisn ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.inversePrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomInkWell(
                                        borderRadius: 999,
                                        defaultColor: AppColors.primary,
                                        onTap: () async {
                                          var result = await sl<
                                                  UpdateStudentRegisterUsecase>()
                                              .call(params: students.nisn);
                                          result.fold(
                                            (error) {
                                              var snackbar = const SnackBar(
                                                content:
                                                    Text("Gagal Mengubah Data"),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
                                            },
                                            (r) {
                                              context
                                                  .read<
                                                      GetStudentRegistrationCubit>()
                                                  .displayStudentRegistration();
                                              var snackbar = const SnackBar(
                                                content: Text(
                                                    "Data Berhasil Diubah"),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
                                            },
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
                                          var result =
                                              await sl<DeleteStudentUsecase>()
                                                  .call(params: students.nisn);
                                          result.fold(
                                            (error) {
                                              var snackbar = const SnackBar(
                                                content:
                                                    Text("Gagal Mengubah Data"),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
                                            },
                                            (r) {
                                              context
                                                  .read<
                                                      GetStudentRegistrationCubit>()
                                                  .displayStudentRegistration();
                                              var snackbar = const SnackBar(
                                                content: Text(
                                                    "Akun berhasil dihapus"),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackbar);
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
                            );
                          }
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: height * 0.01),
                        itemCount: state.students.length + 1,
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
    );
  }
}
