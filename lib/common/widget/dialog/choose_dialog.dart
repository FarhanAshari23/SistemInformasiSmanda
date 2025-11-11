import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/auth/widgets/button_role.dart';
import '../inkwell/custom_inkwell.dart';

class ChooseDialog extends StatelessWidget {
  final double height;
  final String title;
  final Function() onTap;
  const ChooseDialog({
    super.key,
    required this.height,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height * 0.02),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.inversePrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonRole(
                    onPressed: onTap,
                    title: 'Setuju',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomInkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: 12,
                      defaultColor: AppColors.primary,
                      child: SizedBox(
                        height: height * 0.085,
                        child: const Center(
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: AppColors.inversePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
