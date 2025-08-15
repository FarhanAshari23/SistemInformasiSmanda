import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/accept_student_register_usecase.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_state.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
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
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text(
                      'Pilih akun yang ingin konfirmasi registrasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
              BlocBuilder<GetStudentRegistrationCubit,
                  StudentsRegistrationState>(
                builder: (context, state) {
                  if (state is StudentsRegistrationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is StudentsRegistrationLoaded) {
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final students = state.students[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                CustomInkWell(
                                  borderRadius: 999,
                                  defaultColor: AppColors.primary,
                                  onTap: () async {
                                    var result =
                                        await sl<UpdateStudentRegisterUsecase>()
                                            .call(params: students.nisn);
                                    result.fold(
                                      (error) {
                                        var snackbar = const SnackBar(
                                          content: Text("Gagal Mengubah Data"),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                      },
                                      (r) {
                                        context
                                            .read<GetStudentRegistrationCubit>()
                                            .displayStudentRegistration();
                                        var snackbar = const SnackBar(
                                          content: Text("Data Berhasil Diubah"),
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
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: height * 0.01),
                        itemCount: state.students.length,
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
