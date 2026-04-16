import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/forgot_password_usecase.dart';
import '../widgets/button_role.dart';
import 'login_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController emailC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonLoadingState) return;
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              AppNavigator.push(
                context,
                SuccesPage(
                  page: LoginView(),
                  title:
                      "Pesan lupa password berhasil dikirimkan, silakan cek email anda",
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(isBackViewed: true),
                SizedBox(height: height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.girlStudentSmile,
                        height: height * 0.1,
                        width: height * 0.07,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Silakan masukkan email anda. Input password baru akan dikirimkan melalui email yang anda berikan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: TextField(
                    controller: emailC,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(builder: (context) {
                    return ButtonRole(
                      onPressed: () {
                        context.read<ButtonStateCubit>().execute(
                              usecase: ForgotPasswordUsecase(),
                              params: emailC.text,
                            );
                      },
                      title: 'Ubah Password',
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
