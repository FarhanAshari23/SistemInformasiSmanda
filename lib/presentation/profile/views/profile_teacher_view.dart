import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/profile/profile_info_cubit.dart';
import '../../../common/bloc/profile/profile_info_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class ProfileTeacher extends StatelessWidget {
  const ProfileTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser("Teachers"),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(
                isBackViewed: false,
                isLogout: true,
                isProfileViewed: false,
              ),
              BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                builder: (context, state) {
                  if (state is ProfileInfoLoading) {
                    return Container(
                      width: double.infinity,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.secondary,
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Silakan Tunggu Sebentar',
                              style: TextStyle(
                                color: AppColors.inversePrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ProfileInfoLoaded) {
                    return Text(
                      state.teacherEntity?.nama ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    );
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
