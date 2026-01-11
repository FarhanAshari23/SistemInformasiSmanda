// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/schedule/update_schedule_usecase.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_cubit.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/schedule/schedule.dart';
import '../bloc/add_schedule_cubit.dart';
import '../bloc/class_field_cubit.dart';
import '../bloc/create_schedule_cubit.dart';
import '../bloc/create_schedule_state.dart';
import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../bloc/edit_schedule_cubit.dart';
import '../widgets/add_schedule_button.dart';
import '../widgets/card_schedule.dart';

class EditScheduleDetailView extends StatefulWidget {
  final String kelas;
  final ScheduleEntity schedule;
  const EditScheduleDetailView({
    super.key,
    required this.kelas,
    required this.schedule,
  });

  @override
  State<EditScheduleDetailView> createState() => _EditScheduleDetailState();
}

class _EditScheduleDetailState extends State<EditScheduleDetailView> {
  late TextEditingController _kelasC;

  @override
  void initState() {
    super.initState();
    _kelasC = TextEditingController(text: widget.kelas);
  }

  @override
  void dispose() {
    super.dispose();
    _kelasC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClassFieldCubit()..updateText(widget.kelas),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) =>
              CreateScheduleCubit(initialSchedules: widget.schedule.hari),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()..displayTeacher(),
        ),
        BlocProvider(
          create: (context) => GetActivitiesCubit()..displayActivites(),
        ),
        BlocProvider(
          create: (context) => EditScheduleCubit(),
        ),
        BlocProvider(
          create: (context) => AddScheduleCubit(),
        ),
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailureState) {
            var snackbar = SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
          if (state is ButtonSuccessState) {
            Future.microtask(() {
              final ctx = context;

              ctx.read<GetAllJadwalCubit>().displayAllJadwal();

              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(content: Text("Berhasil mengubah jadwal")),
              );

              Navigator.pop(ctx);
            });
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Masukan informasi yang sesuai pada kolom berikut:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ClassFieldCubit, String>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _kelasC,
                        autocorrect: false,
                        onChanged: (value) {
                          context.read<ClassFieldCubit>().updateText(value);
                        },
                        decoration: const InputDecoration(
                          hintText: "Nama Kelas:",
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<ClassFieldCubit, String>(
                  builder: (context, state) {
                    if (state.isEmpty) {
                      return Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            const SizedBox(height: 24),
                            Image.asset(
                              AppImages.emptyRegistrationChara,
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Data nama kelas masih kosong harap isi terlebih dahulu',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return BlocBuilder<CreateScheduleCubit,
                        CreateScheduleState>(
                      builder: (context, state) {
                        return Expanded(
                          child: ListView(
                            children: state.schedules.keys.map((day) {
                              return Card(
                                margin: const EdgeInsets.all(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        children: [
                                          for (int i = 0;
                                              i < state.schedules[day]!.length;
                                              i++)
                                            CardSchedule(
                                              day: day,
                                              index: i,
                                              schedule:
                                                  state.schedules[day]![i],
                                            ),
                                          AddScheduleButton(
                                            day: day,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
                Builder(builder: (context) {
                  final cubit = context.read<CreateScheduleCubit>();
                  return BasicButton(
                    onPressed: () async {
                      final allEmpty = cubit.state.schedules.values.every(
                        (list) => list.isEmpty,
                      );
                      if (allEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Tolong isi semua card jadwal yang sudah tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        context.read<ButtonStateCubit>().execute(
                              usecase: UpdateScheduleUsecase(),
                              params: ScheduleEntity(
                                oldNamaKelas: widget.kelas,
                                kelas: _kelasC.text,
                                hari: cubit.state.schedules,
                              ),
                            );
                      }
                    },
                    title: 'Ubah Jadwal',
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
