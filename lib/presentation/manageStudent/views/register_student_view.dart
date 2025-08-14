import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_state.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

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
                    return Text('Sukses ambil data, nama ${state.students}');
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
