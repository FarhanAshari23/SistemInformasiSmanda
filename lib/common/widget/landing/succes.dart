import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_lotties.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';

import '../../helper/app_navigation.dart';
import '../appbar/basic_appbar.dart';

class SuccesPage extends StatelessWidget {
  final String title;
  final Widget page;
  const SuccesPage({
    super.key,
    required this.page,
    required this.title,
  });

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
            SizedBox(height: height * 0.1),
            SizedBox(
              width: width * 0.6,
              height: height * 0.25,
              child: Lottie.asset(AppLotties.success),
            ),
            SizedBox(height: height * 0.05),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.06),
            GestureDetector(
              onTap: () => AppNavigator.pushReplacement(
                context,
                page,
              ),
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
    );
  }
}
