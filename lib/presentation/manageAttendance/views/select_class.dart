import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/attendances_kelas_sepuluh_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/search_student_attendance.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => GetAllKelasCubit()..displayAll(),
        child: SafeArea(
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
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardKelas(
                          title: 'Kelas\n10',
                          nextPage: BlocProvider.value(
                            value: context.read<GetAllKelasCubit>()
                              ..displayAll(),
                            child: AttendancesKelasSepuluhView(
                              date: date,
                              kelas: 10,
                            ),
                          ),
                        ),
                        CardKelas(
                          title: 'Kelas\n11',
                          nextPage: BlocProvider.value(
                            value: context.read<GetAllKelasCubit>()
                              ..displayAll(),
                            child: AttendancesKelasSepuluhView(
                              date: date,
                              kelas: 11,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardKelas(
                          title: 'Kelas\n12',
                          nextPage: BlocProvider.value(
                            value: context.read<GetAllKelasCubit>()
                              ..displayAll(),
                            child: AttendancesKelasSepuluhView(
                              date: date,
                              kelas: 12,
                            ),
                          ),
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
      ),
    );
  }
}
