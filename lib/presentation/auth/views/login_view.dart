import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_lotties.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/usecases/auth/profile_student_usecase.dart';
import '../../../domain/usecases/auth/profile_teacher_usecase.dart';
import '../../../domain/usecases/auth/signin.dart';
import '../../../service_locator.dart';
import '../../home/views/home_view.dart';
import '../../home/views/home_view_admin.dart';
import '../../profile/views/profile_teacher_view.dart';
import '../bloc/password_cubit.dart';
import '../widgets/button_role.dart';
import 'add_account_detail_view.dart';
import 'forget_password_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 90),
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ButtonStateCubit(),
              ),
              BlocProvider(
                create: (context) => PasswordCubit(),
              ),
            ],
            child: BlocListener<ButtonStateCubit, ButtonState>(
              listener: (context, state) async {
                String email = _emailC.text;
                if (state is ButtonFailureState) {
                  var snackbar = SnackBar(
                    content: Text(state.errorMessage),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                if (state is ButtonSuccessState) {
                  var studentProfile =
                      await sl<ProfileStudentUsecase>().call(params: email);
                  return studentProfile.fold(
                    (l) async {
                      var teacherProfile =
                          await sl<ProfileTeacherUsecase>().call(params: email);
                      return teacherProfile.fold(
                        (l) {
                          AppNavigator.pushAndRemoveUntil(
                            context,
                            const HomeViewAdmin(),
                          );
                        },
                        (data) {
                          AppNavigator.pushAndRemoveUntil(
                            context,
                            ProfileTeacher(
                              teacher: data,
                            ),
                          );
                        },
                      );
                    },
                    (data) {
                      AppNavigator.pushAndRemoveUntil(
                        context,
                        HomeView(student: data),
                      );
                    },
                  );
                }
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        height: height * 0.2,
                        child: Lottie.asset(AppLotties.imageIntro),
                      ),
                      const Text(
                        'Selamat Datang di Aplikasi\nSistem Informasi SMA N 2 Metro',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  const Text(
                    'Silakan Login Terlebih Dahulu:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: height * 0.05),
                  TextField(
                    controller: _emailC,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Email:',
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  BlocBuilder<PasswordCubit, bool>(
                    builder: (context, isPasswordHidden) {
                      return TextField(
                        obscureText: isPasswordHidden,
                        controller: _passC,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Password:',
                          suffixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<PasswordCubit>()
                                  .togglePasswordVisibility();
                            },
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () => AppNavigator.push(
                        context,
                        const ForgetPasswordView(),
                      ),
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.07),
                  _continueButton(context),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki akun?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      TextButton(
                        onPressed: () => AppNavigator.push(
                          context,
                          const AddAccountView(),
                        ),
                        child: const Text(
                          'Buat Akun',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return ButtonRole(
          title: 'Login',
          onPressed: () {
            if (_emailC.text.isEmpty || _passC.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Tolong Isi Kolom Email dan Password yang Disediakan',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else {
              context.read<ButtonStateCubit>().execute(
                    usecase: SignInUsecase(),
                    params: StudentEntity(
                      email: _emailC.text.toString(),
                      password: _passC.text.toString(),
                    ),
                  );
            }
          },
        );
      },
    );
  }
}
