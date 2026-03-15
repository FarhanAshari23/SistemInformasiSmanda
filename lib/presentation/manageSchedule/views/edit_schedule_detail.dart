import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/schedule/jadwal_display_cubit.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/schedule/jadwal_display_state.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/helper/convert_list_day_entity.dart';
import '../../../common/helper/string_helper.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/dialog/confirmation_dialog.dart';
import '../../../common/widget/searchbar/search_teachers_views.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/schedule/update_schedule_usecase.dart';
import '../bloc/add_schedule_cubit.dart';
import '../bloc/form_field_cubit.dart';
import '../bloc/create_schedule_cubit.dart';
import '../bloc/create_schedule_state.dart';
import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../bloc/edit_schedule_cubit.dart';
import '../bloc/form_field_state.dart';
import '../bloc/schedule_picker_cubit.dart';
import '../widgets/add_schedule_button.dart';
import '../widgets/card_schedule.dart';

class EditScheduleDetailView extends StatefulWidget {
  final KelasEntity schedule;
  const EditScheduleDetailView({
    super.key,
    required this.schedule,
  });

  @override
  State<EditScheduleDetailView> createState() => _EditScheduleDetailState();
}

class _EditScheduleDetailState extends State<EditScheduleDetailView> {
  late TextEditingController _kelasC;
  late TextEditingController _waliKelasC;
  late int? teacherId;

  @override
  void initState() {
    super.initState();
    _kelasC = TextEditingController(text: widget.schedule.className);
    _waliKelasC = TextEditingController(text: widget.schedule.teacherName);
    teacherId = widget.schedule.teacherId;
  }

  @override
  void dispose() {
    super.dispose();
    _kelasC.dispose();
    _waliKelasC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FormFieldCubit()..updateClass(widget.schedule.className!),
        ),
        BlocProvider(
          create: (context) =>
              FormFieldCubit()..updateTeacher(widget.schedule.teacherName!),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) =>
              JadwalDisplayCubit()..displayJadwal(params: widget.schedule.id),
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
        BlocProvider(
          create: (context) => PickerCubit(),
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
            var snackbar = const SnackBar(
              content: Text("Berhasil mengubah jadwal"),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          }
        },
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final bool shouldPop =
                await ConfirmationDialog.showBackDialog(context) ?? false;

            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
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
                  BlocBuilder<FormFieldCubit, FormFieldsState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            TextField(
                              controller: _waliKelasC,
                              readOnly: true,
                              autocorrect: false,
                              onChanged: (value) {
                                context
                                    .read<FormFieldCubit>()
                                    .updateTeacher(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Wali Kelas:",
                              ),
                              onTap: () async {
                                TeacherEntity? result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchTeachersViews(),
                                  ),
                                );
                                if (result != null) {
                                  teacherId = result.id;
                                  _waliKelasC.text = result.name ?? '';
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _kelasC,
                              autocorrect: false,
                              onChanged: (value) {
                                context
                                    .read<FormFieldCubit>()
                                    .updateClass(value);
                              },
                              decoration: const InputDecoration(
                                hintText: "Nama Kelas:",
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  BlocBuilder<FormFieldCubit, FormFieldsState>(
                    builder: (context, state) {
                      if (state.isClassEmpty && state.isTeacherEmpty) {
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
                      return BlocBuilder<JadwalDisplayCubit,
                          JadwalDisplayState>(
                        builder: (context, stateJadwal) {
                          if (stateJadwal is JadwalDisplayLoading) {
                            return const Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 18),
                                    Text(
                                      "Memuat jadwal...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          if (stateJadwal is JadwalDisplayLoaded) {
                            return BlocProvider(
                              create: (context) => CreateScheduleCubit(
                                initialSchedules:
                                    groupSchedules(stateJadwal.jadwals),
                              ),
                              child: BlocBuilder<CreateScheduleCubit,
                                  CreateScheduleState>(
                                builder: (context, createState) {
                                  return BlocBuilder<PickerCubit, String>(
                                    builder: (context, pickerState) {
                                      return Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView(
                                                physics: pickerState == "show"
                                                    ? const NeverScrollableScrollPhysics()
                                                    : const BouncingScrollPhysics(),
                                                children: createState
                                                    .schedules.keys
                                                    .map((day) {
                                                  return Card(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            day,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .primary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Column(
                                                            children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      createState
                                                                          .schedules[
                                                                              day]!
                                                                          .length;
                                                                  i++)
                                                                CardSchedule(
                                                                  day: day,
                                                                  index: i,
                                                                  schedule: createState
                                                                          .schedules[
                                                                      day]![i],
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
                                            ),
                                            Builder(builder: (context) {
                                              final cubit = context
                                                  .read<CreateScheduleCubit>();
                                              return BasicButton(
                                                onPressed: () async {
                                                  final allEmpty = cubit
                                                      .state.schedules.values
                                                      .every(
                                                    (list) => list.isEmpty,
                                                  );
                                                  if (allEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text(
                                                          'Tolong isi semua card jadwal yang sudah tersedia',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    final schedulesMap =
                                                        cubit.state.schedules;
                                                    final flatSchedules =
                                                        schedulesMap.values
                                                            .expand(
                                                                (list) => list)
                                                            .toList();
                                                    List<int> requestId =
                                                        StringHelper
                                                            .extractFirstAndLastNumbers(
                                                                _kelasC.text);
                                                    context
                                                        .read<
                                                            ButtonStateCubit>()
                                                        .execute(
                                                          usecase:
                                                              UpdateScheduleUsecase(),
                                                          params: KelasEntity(
                                                            id: widget
                                                                .schedule.id,
                                                            className:
                                                                _kelasC.text,
                                                            degree:
                                                                requestId[0],
                                                            sequence:
                                                                requestId[1],
                                                            teacherId:
                                                                teacherId,
                                                            schedules:
                                                                flatSchedules,
                                                          ),
                                                        );
                                                  }
                                                },
                                                title: 'Ubah Jadwal',
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }
                          return const Text("Default State");
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
