import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/edit_student_detail_class_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/search_student_edit.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/widget/card/card_kelas.dart';
import '../../../common/widget/card/card_search.dart';

class EditStudentView extends StatelessWidget {
  const EditStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Silakan Pilih Kelas:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardKelas(
                        title: 'Kelas\n10',
                        nextPage: BlocProvider.value(
                          value: context.read<GetAllKelasCubit>(),
                          child: const EditStudentDetailClassView(
                            kelas: 10,
                          ),
                        ),
                      ),
                      CardKelas(
                        title: 'Kelas\n11',
                        nextPage: BlocProvider.value(
                          value: context.read<GetAllKelasCubit>(),
                          child: const EditStudentDetailClassView(
                            kelas: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardKelas(
                        title: 'Kelas\n12',
                        nextPage: BlocProvider.value(
                          value: context.read<GetAllKelasCubit>(),
                          child: const EditStudentDetailClassView(
                            kelas: 12,
                          ),
                        ),
                      ),
                      const CardSearch(
                        nextPage: SearchStudentEdit(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
