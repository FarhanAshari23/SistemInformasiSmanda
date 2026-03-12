import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/add_schedule_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';

import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../../../common/bloc/activities/get_activities_state.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/add_schedule_state.dart';
import '../bloc/schedule_picker_cubit.dart';
import 'duration_picker.dart';

class AddScheduleButton extends StatefulWidget {
  final String day;
  const AddScheduleButton({
    super.key,
    required this.day,
  });

  @override
  State<AddScheduleButton> createState() => _AddScheduleButtonState();
}

class _AddScheduleButtonState extends State<AddScheduleButton> {
  late String statePicker;
  final _pelaksanaC = TextEditingController();
  final _kegiatanC = TextEditingController();
  final _durasiMulaiC = TextEditingController();
  final _durasiSelesaiC = TextEditingController();
  int? teacherId, subjectId;

  @override
  void dispose() {
    _pelaksanaC.dispose();
    _kegiatanC.dispose();
    _durasiMulaiC.dispose();
    _durasiSelesaiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubitCreateSchedule = context.read<CreateScheduleCubit>();
    final cubitAddSchedule = context.read<AddScheduleCubit>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      builder: (context, state) {
        final cardState = state.getCardState(widget.day);
        final isAdding = cardState.isAdding;
        final isPickerVisible = cardState.isPickerVisible;
        final selectedStartTimeTemp = cardState.selectedStartTimeTemp;
        final selectedEndTimeTemp = cardState.selectedEndTimeTemp;
        final FocusNode pelaksanaFocus = FocusNode();

        if (isAdding) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<TeacherCubit, TeacherState>(
                    builder: (context, state) {
                      if (state is TeacherLoading) {
                        return TextField(
                          controller: _pelaksanaC,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Pelaksana:',
                          ),
                        );
                      }
                      if (state is TeacherLoaded) {
                        return DropdownMenu<int>(
                          width: width * 0.92,
                          enableFilter: true,
                          requestFocusOnTap: false,
                          focusNode: pelaksanaFocus,
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: AppColors.tertiary,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          menuHeight: 200,
                          menuStyle: MenuStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            alignment: Alignment.bottomLeft,
                            visualDensity: VisualDensity.compact,
                            maximumSize: WidgetStateProperty.all(
                              Size(width * 0.92, 200),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          hintText: 'Pelaksana:',
                          dropdownMenuEntries: state.teachers.map((doc) {
                            return DropdownMenuEntry<int>(
                              value: doc.id ?? 0,
                              label: doc.name ?? '',
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value != null) {
                              setState(() {
                                teacherId = value;
                              });
                            }
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<GetActivitiesCubit, GetActivitiesState>(
                    builder: (context, state) {
                      if (state is GetActivitiesLoading) {
                        return TextField(
                          controller: _kegiatanC,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Kegiatan:',
                          ),
                        );
                      }
                      if (state is GetActivitiesLoaded) {
                        return DropdownMenu<int>(
                          width: width * 0.92,
                          enableFilter: true,
                          requestFocusOnTap: false,
                          focusNode: pelaksanaFocus,
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: AppColors.tertiary,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          menuHeight: 200,
                          menuStyle: MenuStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            alignment: Alignment.bottomLeft,
                            visualDensity: VisualDensity.compact,
                            maximumSize: WidgetStateProperty.all(
                              Size(width * 0.92, 200),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          hintText: 'Pelaksana:',
                          dropdownMenuEntries: state.activities.map((doc) {
                            return DropdownMenuEntry<int>(
                              value: doc.id,
                              label: doc.name,
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value != null) {
                              setState(() {
                                subjectId = value;
                              });
                            }
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      'Durasi:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _durasiMulaiC,
                          decoration: const InputDecoration(
                            hintText: 'Mulai:',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              statePicker = 'start';
                            });
                            context.read<PickerCubit>().show();
                            cubitAddSchedule.showPicker(widget.day);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '-',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: _durasiSelesaiC,
                          decoration: const InputDecoration(
                            hintText: 'Selesai:',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              statePicker = 'end';
                            });
                            context.read<PickerCubit>().show();
                            cubitAddSchedule.showPicker(widget.day);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomInkWell(
                        borderRadius: 12,
                        defaultColor: AppColors.primary,
                        onTap: () {
                          if (teacherId != null ||
                              _durasiMulaiC.text.isEmpty ||
                              _durasiMulaiC.text.isEmpty ||
                              subjectId != null) {
                            var snackbar = const SnackBar(
                              content: Text("Tolong isi semua field yang ada"),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            cubitCreateSchedule.addActivity(
                              widget.day,
                              _durasiMulaiC.text,
                              _durasiSelesaiC.text,
                              teacherId,
                              subjectId,
                            );
                            _kegiatanC.clear();
                            _durasiMulaiC.clear();
                            _durasiSelesaiC.clear();
                            _pelaksanaC.clear();
                            cubitAddSchedule.toggleAdding(widget.day);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomInkWell(
                        borderRadius: 12,
                        defaultColor: Colors.red,
                        onTap: () {
                          _kegiatanC.clear();
                          _durasiMulaiC.clear();
                          _durasiSelesaiC.clear();
                          _pelaksanaC.clear();
                          cubitAddSchedule.toggleAdding(widget.day);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.inversePrimary,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              if (isPickerVisible)
                Align(
                  alignment: Alignment.center,
                  child: DurationPicker(
                    height: height,
                    width: width,
                    onDateTimeChanged: (p0) {
                      if (statePicker == 'start') {
                        cubitAddSchedule.updateStartTempTime(widget.day, p0);
                      } else {
                        cubitAddSchedule.updateEndTempTime(widget.day, p0);
                      }
                    },
                    simpan: () {
                      final selectedTemp = statePicker == 'start'
                          ? selectedStartTimeTemp
                          : selectedEndTimeTemp;

                      if (selectedTemp != null) {
                        final formattedTime =
                            '${selectedTemp.hour.toString().padLeft(2, '0')}:${selectedTemp.minute.toString().padLeft(2, '0')}';

                        if (statePicker == 'start') {
                          _durasiMulaiC.text = formattedTime;
                        } else {
                          _durasiSelesaiC.text = formattedTime;
                        }
                      }
                      context.read<PickerCubit>().hide();

                      cubitAddSchedule.hidePicker(widget.day);
                    },
                    batal: () {
                      context.read<PickerCubit>().hide();

                      cubitAddSchedule.hidePicker(widget.day);
                    },
                  ),
                ),
            ],
          );
        }

        return TextButton.icon(
          onPressed: () => cubitAddSchedule.toggleAdding(widget.day),
          label: const Text("Tambah Jadwal"),
          icon: const Icon(Icons.add),
        );
      },
    );
  }
}
