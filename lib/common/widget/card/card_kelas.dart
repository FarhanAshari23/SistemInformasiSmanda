import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardKelas extends StatelessWidget {
  final Widget nextPage;
  final String title;
  const CardKelas({
    super.key,
    required this.title,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => AppNavigator.push(context, nextPage),
      child: Container(
        width: width * 0.435,
        height: height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.secondary,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.inversePrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
