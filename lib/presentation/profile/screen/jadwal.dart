import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal_jumat.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal_kamis.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal_rabu.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal_selasa.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal_senin.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bar_days_cubit.dart';
import '../bloc/jadwal_display_cubit.dart';

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> dayName = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
    ];
    List<Widget> screenJadwal = [
      const JadwalSenin(),
      const JadwalSelasa(),
      const JadwalRabu(),
      const JadwalKamis(),
      const JadwalJumat(),
    ];
    return Column(
      children: [
        const Text(
          'Jadwal Pelajaran',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: height * 0.01),
        SizedBox(
          width: double.infinity,
          height: height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dayName.length,
            itemBuilder: (context, index) => CustomInkWell(
              onTap: () {
                context.read<BarDaysCubit>().changeColor(index);
                context
                    .read<JadwalDisplayCubit>()
                    .displayJadwal(params: dayName[index]);
              },
              defaultColor: context.watch<BarDaysCubit>().state == index
                  ? AppColors.primary
                  : AppColors.inversePrimary,
              child: SizedBox(
                width: width * 0.1825,
                height: height * 0.1,
                child: Center(
                  child: Text(
                    dayName[index],
                    style: TextStyle(
                      color: context.watch<BarDaysCubit>().state == index
                          ? AppColors.inversePrimary
                          : AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        SizedBox(
          width: double.infinity,
          height: height * 0.4,
          child: Builder(builder: (context) {
            return screenJadwal[context.watch<BarDaysCubit>().state];
          }),
        ),
      ],
    );
  }
}
