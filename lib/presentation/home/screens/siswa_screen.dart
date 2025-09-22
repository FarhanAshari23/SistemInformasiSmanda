import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_search.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/kelas_detail_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/search_screen_student.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/widget/card/card_kelas.dart';

class SiswaScreen extends StatelessWidget {
  const SiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardKelas(
                  title: 'Kelas\n10',
                  nextPage: BlocProvider.value(
                    value: context.read<GetAllKelasCubit>(),
                    child: const KelasDetailView(
                      kelas: 10,
                    ),
                  ),
                ),
                CardKelas(
                  title: 'Kelas\n11',
                  nextPage: BlocProvider.value(
                    value: context.read<GetAllKelasCubit>(),
                    child: const KelasDetailView(
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
                    child: const KelasDetailView(
                      kelas: 12,
                    ),
                  ),
                ),
                const CardSearch(
                  nextPage: SearchScreenStudent(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
