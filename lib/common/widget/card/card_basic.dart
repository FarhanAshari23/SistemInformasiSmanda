import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardBasic extends StatelessWidget {
  final String title;
  final String image;
  final Color color, textColor;
  final VoidCallback onpressed;

  const CardBasic({
    super.key,
    required this.title,
    required this.image,
    required this.onpressed,
    this.color = AppColors.secondary,
    this.textColor = AppColors.inversePrimary,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      onTap: onpressed,
      borderRadius: 12,
      defaultColor: color,
      child: SizedBox(
        width: width * 0.435,
        height: height * 0.25,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            children: [
              Container(
                width: width * 0.25,
                height: height * 0.12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Image.asset(
                    image,
                    scale: 2.5,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
