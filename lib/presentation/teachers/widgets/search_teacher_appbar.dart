import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/get_teacher_cubit.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../manageNews/bloc/select_teacher_name_cubit.dart';

class SearchTeacherAppbar extends StatelessWidget {
  final bool isTeacherGolang;
  SearchTeacherAppbar({
    super.key,
    this.isTeacherGolang = false,
  });

  final TextEditingController searchC = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      isTeacherGolang
                          ? context.read<GetTeacherNameCubit>().displayInitial()
                          : context.read<GetTeacherCubit>().displayInitial();
                    } else {
                      isTeacherGolang
                          ? context
                              .read<GetTeacherNameCubit>()
                              .displayTeacher(params: value)
                          : context
                              .read<GetTeacherCubit>()
                              .displayTeacher(params: value);
                    }
                  },
                  decoration: const InputDecoration(
                    fillColor: AppColors.inversePrimary,
                    hintText: 'Masukkan Nama:',
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
