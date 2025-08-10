import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/assets/app_lotties.dart';
import '../../../core/configs/theme/app_colors.dart';

class SuccesAddAttandance extends StatelessWidget {
  final UserEntity userEntity;
  const SuccesAddAttandance({
    super.key,
    required this.userEntity,
  });

  @override
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: false,
              isProfileViewed: false,
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                height: height * 0.7,
                child: Column(
                  children: [
                    SizedBox(
                      width: width * 0.6,
                      height: height * 0.25,
                      child: Lottie.asset(AppLotties.success),
                    ),
                    SizedBox(height: height * 0.05),
                    Text(
                      'Sukses merekam kehadiran ${userEntity.nama}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.06),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Container(
                          width: width * 0.45,
                          height: height * 0.1,
                          color: AppColors.primary,
                          child: const Center(
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.inversePrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
