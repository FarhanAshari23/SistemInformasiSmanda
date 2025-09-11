import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/teacher/teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/kelas/kelas.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/durasi_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/activities/get_activities_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/widgets/add_schedule_button.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/widgets/card_schedule.dart';

import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/schedule/create_class_usecase.dart';
import '../../../domain/usecases/schedule/create_schedule_usecase.dart';
import '../bloc/class_field_cubit.dart';
import '../bloc/create_schedule_cubit.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  final TextEditingController _kelasC = TextEditingController();

  @override
  void dispose() {
    _kelasC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClassFieldCubit(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) => CreateScheduleCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()..displayTeacher(),
        ),
        BlocProvider(
          create: (context) => GetActivitiesCubit()..displayActivites(),
        ),
        BlocProvider(
          create: (context) => DurasiCubit(),
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
                const SizedBox(height: 24),
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
                                      // Daftar aktivitas
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

                                          // Tombol tambah
                                          AddScheduleButton(day: day),
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
                  return BasicButton(
                    onPressed: () async {
                      final cubit = context.read<CreateScheduleCubit>();
                      await context.read<ButtonStateCubit>().execute(
                            usecase: CreateClassUsecase(),
                            params: KelasEntity(
                              kelas: _kelasC.text,
                              order: 0,
                              degree: 0,
                            ),
                          );
                      await context.read<ButtonStateCubit>().execute(
                          usecase: CreateScheduleUsecase(),
                          params: ScheduleEntity(
                            kelas: _kelasC.text,
                            hari: cubit.state.schedules,
                          ));
                      var snackbar = SnackBar(
                        content: Text(
                          'Berhasil menambahkan jadwal untuk kelas ${_kelasC.text}',
                        ),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.pop(context);
                    },
                    title: 'Tambah Jadwal',
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
