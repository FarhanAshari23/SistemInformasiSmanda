import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardNews extends StatelessWidget {
  final String title;
  final String from;
  final String to;
  final VoidCallback onPressed;
  const CardNews({
    super.key,
    required this.title,
    required this.from,
    required this.to,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: Colors.white,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Dari $from untuk $to',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.secondary,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.inversePrimary,
                  size: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
