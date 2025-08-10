import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/auth/check_admin.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/login_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/home_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/splash/bloc/splash_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/splash/bloc/splash_state.dart';
import 'package:new_sistem_informasi_smanda/service_locator.dart';

import '../../home/views/home_view_admin.dart';

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
