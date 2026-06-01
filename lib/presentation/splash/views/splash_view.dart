import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/user_validation_usecase.dart';
import '../../../service_locator.dart';
import '../../auth/views/login_view.dart';
import '../../home/views/home_view.dart';
import '../../home/views/home_view_admin.dart';
import '../../profile/views/teacher/profile_teacher_view.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is UnAuthenticated) {
          AppNavigator.pushReplacement(context, LoginView());
        }
        if (state is Authenticated) {
          String? email = FirebaseAuth.instance.currentUser?.email;
          var user = await sl<UserValidationUseCase>().call(params: email);
          return user.fold(
            (l) {
              var snackbar = SnackBar(
                content: Text(l.toString()),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
            (data) {
              final String role = data["role"];
              final int id = data["id"];
              if (role == "student") {
                AppNavigator.pushAndRemoveUntil(
                  context,
                  HomeView(studentId: id),
                );
              }
              if (role == "teacher") {
                AppNavigator.pushAndRemoveUntil(
                  context,
                  ProfileTeacher(teacherId: id),
                );
              }
              if (role == "admin") {
                AppNavigator.pushAndRemoveUntil(
                  context,
                  const HomeViewAdmin(),
                );
              }
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: SizedBox(
            width: 160,
            height: 160,
            child: Image.asset(AppImages.logoSMA),
          ),
        ),
      ),
    );
  }
}
