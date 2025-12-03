import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/check_admin.dart';
import '../../../domain/usecases/auth/check_teacher_usecase.dart';
import '../../../service_locator.dart';
import '../../auth/views/login_view.dart';
import '../../home/views/home_view.dart';
import '../../home/views/home_view_admin.dart';
import '../../teachers/views/profile_teacher.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) async {
        if (state is UnAuthenticated) {
          AppNavigator.push(context, LoginView());
        }
        if (state is Authenticated) {
          var resultTeacher = await sl<CheckTeacherUsecase>().call();
          return resultTeacher.fold(
            (l) async {
              var resultAdmin = await sl<IsAdminUsecase>().call();
              return resultAdmin.fold(
                (error) {
                  var snackbar = SnackBar(content: Text(error));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                (r) {
                  bool checkAdmin = true;
                  if (checkAdmin == r) {
                    AppNavigator.pushReplacement(
                      context,
                      const HomeViewAdmin(),
                    );
                  } else {
                    AppNavigator.push(
                      context,
                      const HomeView(),
                    );
                  }
                },
              );
            },
            (r) {
              AppNavigator.pushReplacement(
                context,
                const ProfileTeacher(),
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
