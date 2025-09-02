import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../bloc/kelas/stundets_cubit.dart';

class SearchStudentAppBar extends StatefulWidget {
  const SearchStudentAppBar({super.key});

  @override
  State<SearchStudentAppBar> createState() => _SearchStudentAppBarState();
}

class _SearchStudentAppBarState extends State<SearchStudentAppBar> {
  final TextEditingController searchC = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    searchC.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // cancel timer sebelumnya
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // set timer baru
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        context.read<StudentsDisplayCubit>().displayInitial();
      } else {
        context.read<StudentsDisplayCubit>().displayStudents(params: value);
      }
    });
  }

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
                  onChanged: _onSearchChanged,
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
