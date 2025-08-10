import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/select_class.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardDate extends StatelessWidget {
  final String date;
  const CardDate({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height * 0.135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.6,
              height: height * 0.1,
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Data Kehadiran pada Tanggal:\n$date',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => AppNavigator.push(context, SelectClass(date: date)),
              child: Container(
                width: width * 0.15,
                height: height * 0.085,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.inversePrimary,
                    size: 24,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
