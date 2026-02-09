import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_lotties.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';

import '../../helper/app_navigation.dart';
import '../appbar/basic_appbar.dart';

class SuccesPage extends StatelessWidget {
  final String title;
  final bool isPop;
  final Function()? onTap;
  final Widget page;
  const SuccesPage({
    super.key,
    required this.page,
    required this.title,
    this.isPop = false,
    this.onTap,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: height * 0.06),
            GestureDetector(
              onTap: () => isPop
                  ? Navigator.pop(context)
                  : AppNavigator.pushReplacement(
                      context,
                      page,
                    ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16)),
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
