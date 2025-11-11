import 'package:flutter/material.dart';

import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';

class ButtonAll extends StatelessWidget {
  final Function() onTap;
  final String title;
  const ButtonAll({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.inversePrimary,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
