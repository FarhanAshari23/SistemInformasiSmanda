import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

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
    double width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      borderRadius: 16,
      onTap: () => AppNavigator.push(context, nextPage),
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.45,
        height: width * 0.45,
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
