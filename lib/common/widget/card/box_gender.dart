// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/gender/gender_selection_cubit.dart';

import '../../../core/configs/theme/app_colors.dart';

class BoxGender extends StatelessWidget {
  BuildContext context;
  int genderIndex;
  final String gender;
  BoxGender({
    super.key,
    required this.context,
    required this.genderIndex,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final selectedIndex = context.watch<GenderSelectionCubit>().state;
    return GestureDetector(
      onTap: () =>
          context.read<GenderSelectionCubit>().selectGender(genderIndex),
      child: Container(
        width: width * 0.45,
        height: height * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedIndex == genderIndex
              ? AppColors.primary
              : AppColors.tertiary,
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: selectedIndex == genderIndex
                  ? AppColors.inversePrimary
                  : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
