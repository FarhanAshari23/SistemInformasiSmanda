import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_sepuluh_display_cubit.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance.dart';

import '../../../common/bloc/kelas/kelas_navigation.dart';
import '../../../common/widget/loading/list_kelas_loading.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/attendance_student_cubit.dart';

class ListKelasSepuluhAttendances extends StatelessWidget {
  final String date;
  const ListKelasSepuluhAttendances({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => KelasSepuluhDisplayCubit()..displaySepuluh(),
      child: SizedBox(
        width: double.infinity,
        height: height * 0.05,
        child: BlocBuilder<KelasSepuluhDisplayCubit, KelasDisplayState>(
          builder: (context, state) {
            if (state is KelasDisplayLoading) {
              return const ListKelasLoading();
            }
            if (state is KelasDisplayLoaded) {
              return BlocProvider(
                create: (context) => KelasNavigationCubit(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.read<KelasNavigationCubit>().changeColor(index);
                        context
                            .read<AttendanceStudentCubit>()
                            .displayAttendanceStudent(
                              params: ParamAttendanceEntity(
                                date: date,
                                kelas: state.kelas[index].data()['value'],
                              ),
                            );
                      },
                      child: Container(
                        width: width * 0.2,
                        height: height * 0.035,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.watch<KelasNavigationCubit>().state ==
                                  index
                              ? AppColors.primary
                              : AppColors.tertiary,
                        ),
                        child: Center(
                          child: Text(
                            state.kelas[index].data()['value'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color:
                                  context.watch<KelasNavigationCubit>().state ==
                                          index
                                      ? AppColors.tertiary
                                      : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(width: width * 0.01),
                  itemCount: state.kelas.length,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
