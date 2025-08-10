import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/attendances_kelas_duabelas_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/attendances_kelas_sebelas_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/attendances_kelas_sepuluh_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/search_student_attendance.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/card_kelas.dart';
import '../../../common/widget/card/card_search.dart';
import '../../../core/configs/theme/app_colors.dart';

class SelectClass extends StatelessWidget {
  final String date;
  const SelectClass({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

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
                        nextPage: AttendancesKelasSepuluhView(date: date),
                      ),
                      CardKelas(
                          title: 'Kelas\n11',
                          nextPage: AttendancesKelasSebelasView(date: date))
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardKelas(
                        title: 'Kelas\n12',
                        nextPage: AttendancesKelasDuabelasView(date: date),
                      ),
                      CardSearch(
                        nextPage: SearchStudentAttendance(
                          date: date,
                        ),
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
