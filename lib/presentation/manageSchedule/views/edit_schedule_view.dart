import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_state.dart';

import '../../../common/widget/appbar/basic_appbar.dart';

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
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              BlocBuilder<GetAllJadwalCubit, GetAllJadwalState>(
                builder: (context, state) {
                  if (state is GetAllJadwalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetAllJadwalLoaded) {
                    final List<String> data =
                        state.jadwals.map((doc) => doc.kelas).toList();
                    data.sort((a, b) {
                      final aParts = a.split(' ');
                      final bParts = b.split(' ');

                      final aTingkat = int.parse(aParts[0]);
                      final aSub = int.parse(aParts[1]);
                      final bTingkat = int.parse(bParts[0]);
                      final bSub = int.parse(bParts[1]);

                      if (aTingkat != bTingkat) {
                        return aTingkat.compareTo(bTingkat);
                      } else {
                        return aSub.compareTo(bSub);
                      }
                    });

                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: AppColors.primary,
                            child: Text(
                              data[index],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
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
