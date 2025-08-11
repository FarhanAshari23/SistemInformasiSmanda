import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_lotties.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/auth/check_admin.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/bloc/password_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/add_student_account.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/widgets/button_role.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/home_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/home_view_admin.dart';

import '../../../data/models/auth/signin_user_req.dart';
import '../../../domain/usecases/auth/signin.dart';
import '../../../service_locator.dart';
//import '../../home/views/home_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _usernameC = TextEditingController();
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
                if (state is ButtonFailureState) {
                  var snackbar = SnackBar(
                    content: Text(state.errorMessage),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                if (state is ButtonSuccessState) {
                  var resultAdmin = await sl<IsAdminUsecase>().call();
                  return resultAdmin.fold(
                    (error) {
                      var snackbar = SnackBar(content: Text(error));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    (r) {
                      bool checkAdmin = true;
                      if (checkAdmin == r) {
                        AppNavigator.pushAndRemoveUntil(
                          context,
                          const HomeViewAdmin(),
                        );
                      } else {
                        AppNavigator.pushAndRemoveUntil(
                          context,
                          const HomeView(),
                        );
                      }
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
                    controller: _usernameC,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Username:',
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
                  SizedBox(height: height * 0.095),
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
                          AddStudentView(),
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
            if (_usernameC.text.isEmpty || _passC.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Tolong Isi Kolom Username dan Password yang Disediakan',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            } else {
              context.read<ButtonStateCubit>().execute(
                    usecase: SignInUsecase(),
                    params: SignInUserReq(
                      email: _usernameC.text.toString(),
                      passwword: _passC.text.toString(),
                    ),
                  );
            }
          },
        );
      },
    );
  }
}
