import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ListKelasLoading extends StatelessWidget {
  const ListKelasLoading({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemBuilder: (context, index) => Container(
        width: width * 0.2,
        height: height * 0.035,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondary,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(
        width: width * 0.01,
      ),
      itemCount: 3,
      scrollDirection: Axis.horizontal,
    );
  }
}
