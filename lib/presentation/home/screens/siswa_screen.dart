import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_search.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/kelas_duabelas_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/kelas_sebelas_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/kelas_sepuluh_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/search_screen_student.dart';

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardKelas(
                  title: 'Kelas\n10',
                  nextPage: KelasSepuluhView(),
                ),
                CardKelas(
                  title: 'Kelas\n11',
                  nextPage: KelasSebelasView(),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardKelas(
                  title: 'Kelas\n12',
                  nextPage: KelasDuabelasView(),
                ),
                CardSearch(
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
