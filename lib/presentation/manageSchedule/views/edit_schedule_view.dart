import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_state.dart';
import 'package:stacked_listview/stacked_listview.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../widgets/edit_schedule_detail.dart';

class EditScheduleView extends StatelessWidget {
  const EditScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => GetAllJadwalCubit()..displayAllJadwal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'Silakan pilih kelas:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              BlocBuilder<GetAllJadwalCubit, GetAllJadwalState>(
                builder: (context, state) {
                  if (state is GetAllJadwalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetAllJadwalLoaded) {
                    return Expanded(
                      child: StackedListView(
                        itemExtent: 200,
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 300,
                          left: 16,
                          right: 16,
                        ),
                        scrollDirection: Axis.horizontal,
                        builder: (context, index) {
                          final schedule = state.jadwals[index];
                          return CustomInkWell(
                            borderRadius: 0,
                            defaultColor: Colors.white,
                            onTap: () => AppNavigator.push(
                              context,
                              BlocProvider.value(
                                value: context.read<GetAllJadwalCubit>(),
                                child: EditScheduleDetail(
                                  kelas: schedule.kelas,
                                  schedule: schedule,
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Kelas\n',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(
                                        text: schedule.kelas,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: state.jadwals.length,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
