import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardEditKelas extends StatelessWidget {
  final String text;
  const CardEditKelas({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.inversePrimary,
          ),
        ),
      ),
    );
  }
}
