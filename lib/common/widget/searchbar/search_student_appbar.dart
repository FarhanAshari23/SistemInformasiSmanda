import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../bloc/kelas/stundets_cubit.dart';

class SearchStudentAppBar extends StatelessWidget {
  const SearchStudentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchC = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: height * 0.1,
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: width * 0.125,
                height: height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.tertiary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.inversePrimary,
                    size: 32,
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.01),
            Container(
              width: width * 0.8,
              height: height * 0.055,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.inversePrimary,
              ),
              child: Center(
                child: TextField(
                  controller: searchC,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<StudentsDisplayCubit>().displayInitial();
                    } else {
                      context
                          .read<StudentsDisplayCubit>()
                          .displayStudents(params: value);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Nama:',
                    fillColor: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
