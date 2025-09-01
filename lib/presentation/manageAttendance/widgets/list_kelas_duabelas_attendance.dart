import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/get_all_kelas_cubit.dart';

import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/kelas/kelas_navigation.dart';
import '../../../common/widget/loading/list_kelas_loading.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/attandance/param_attendance.dart';
import '../bloc/attendance_student_cubit.dart';

class ListKelasDuabelasAttendance extends StatelessWidget {
  final String date;
  const ListKelasDuabelasAttendance({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => GetAllKelasCubit()..displayAll(),
      child: SizedBox(
        width: double.infinity,
        height: height * 0.05,
        child: BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
          builder: (context, state) {
            if (state is KelasDisplayLoading) {
              return const ListKelasLoading();
            }
            if (state is KelasDisplayLoaded) {
              final kelas = state.kelas
                  .where((element) => element['degree'] == 12)
                  .toList();
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
                                kelas: kelas[index].data()['class'],
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
                            kelas[index].data()['class'],
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
                  itemCount: kelas.length,
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
