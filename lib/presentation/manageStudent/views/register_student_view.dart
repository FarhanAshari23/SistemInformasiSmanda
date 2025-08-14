import 'package:flutter/material.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class RegisterStudentView extends StatelessWidget {
  const RegisterStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Pilih akun yang ingin konfirmasi registrasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
