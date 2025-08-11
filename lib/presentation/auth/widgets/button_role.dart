import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/theme/app_colors.dart';

class ButtonRole extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Widget? content;
  const ButtonRole({
    required this.onPressed,
    this.title = '',
    this.height,
    this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _loading(context);
        }
        if (state is ButtonInitialState) {
          return _initial(context);
        }
        return _initial(context);
      },
    );
  }

  Widget _loading(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.8,
        height: height * 0.085,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Text(
              'Tunggu sebentar..',
              style: TextStyle(
                color: Colors.black87, // lebih kontras
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _initial(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width * 0.8,
        height: height * 0.085,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
