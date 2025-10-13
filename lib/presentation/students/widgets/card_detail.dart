import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardDetailSiswa extends StatelessWidget {
  final String title;
  final String content;
  final Function()? onTap;
  const CardDetailSiswa({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: height * 0.0375),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          CustomInkWell(
            defaultColor: AppColors.secondary,
            pressedColor: Colors.black,
            borderRadius: 8,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.inversePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.23,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.tertiary,
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.inversePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
