import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/profile_student_usecase.dart';
import '../../../domain/usecases/auth/profile_teacher_usecase.dart';
import '../../../service_locator.dart';
import '../../auth/views/login_view.dart';
import '../../home/views/home_view.dart';
import '../../home/views/home_view_admin.dart';
import '../../profile/views/profile_teacher_view.dart';
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
          var teacherPage =
              await sl<ProfileTeacherUsecase>().call(params: email);
          return teacherPage.fold(
            (l) async {
              var studentPage =
                  await sl<ProfileStudentUsecase>().call(params: email);
              return studentPage.fold(
                (l) {
                  AppNavigator.pushReplacement(
                    context,
                    const HomeViewAdmin(),
                  );
                },
                (data) {
                  AppNavigator.pushReplacement(
                    context,
                    HomeView(student: data),
                  );
                },
              );
            },
            (data) {
              AppNavigator.pushReplacement(
                context,
                ProfileTeacher(teacher: data),
              );
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
