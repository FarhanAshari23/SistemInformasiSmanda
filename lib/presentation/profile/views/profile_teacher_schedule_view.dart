import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/get_schedule_teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/get_schedule_teacher_state.dart';

class ProfileTeacherScheduleView extends StatelessWidget {
  const ProfileTeacherScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<GetScheduleTeacherCubit, GetScheduleTeacherState>(
      builder: (context, state) {
        if (state is GetScheduleTeacherLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetScheduleTeacherLoaded) {
          if (state.teacherSchedule.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: height * 0.15),
              child: const Center(child: Text('Tidak ada jadwal')),
            );
          } else {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemBuilder: (context, index) {
                final item = state.teacherSchedule[index];
                return Column(
                  children: [
                    Text(item.kegiatan),
                    Text(item.hari),
                    Text(item.jam),
                    Text(item.kelas),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: height * 0.01,
              ),
              itemCount: state.teacherSchedule.length,
            );
          }
        }
        if (state is GetScheduleTeacherFailure) {
          return Container();
        }
        return Container();
      },
    );
  }
}
