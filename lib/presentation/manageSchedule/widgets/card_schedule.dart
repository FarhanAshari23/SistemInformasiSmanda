import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/divided_range_time.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';

import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/add_schedule_cubit.dart';
import '../bloc/add_schedule_state.dart';
import 'duration_picker.dart';

class CardSchedule extends StatefulWidget {
  final String day;
  final int index;
  final DayEntity schedule;
  const CardSchedule({
    super.key,
    required this.day,
    required this.index,
    required this.schedule,
  });

  @override
  State<CardSchedule> createState() => _CardScheduleState();
}

class _CardScheduleState extends State<CardSchedule> {
  late String statePicker;
  final _pelaksanaC = TextEditingController();
  final _kegiatanC = TextEditingController();
  final _durasiMulaiC = TextEditingController();
  final _durasiSelesaiC = TextEditingController();

  @override
  void initState() {
    super.initState();
    DividedRangeTime range = DividedRangeTime.fromString(widget.schedule.jam);
    _pelaksanaC.text = widget.schedule.pelaksana;
    _kegiatanC.text = widget.schedule.kegiatan;
    _durasiMulaiC.text = range.start;
    _durasiSelesaiC.text = range.end;
  }

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<AddScheduleCubit, AddScheduleState>(
      builder: (context, state) {
        final cardState = state.getCardState(widget.day);
        final isAdding = cardState.isAdding;
        final isPickerVisible = cardState.isPickerVisible;
        final selectedStartTimeTemp = cardState.selectedStartTimeTemp;
        final selectedEndTimeTemp = cardState.selectedEndTimeTemp;

        if (isAdding) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        return DropdownMenu<String>(
                          width: width * 0.92,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: _pelaksanaC.text,
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: AppColors.tertiary,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black, // <-- warna hint
                            ),
                          ),
                          menuHeight: 200,
                          hintText: "Pelaksana:",
                          dropdownMenuEntries: state.teacher.map((doc) {
                            final nama = doc.nama;
                            return DropdownMenuEntry(
                              value: nama,
                              label: nama,
                            );
                          }).toList(),
                          onSelected: (value) {
                            context.read<TeacherCubit>().selectItem(value);
                            _pelaksanaC.text = value!;
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 4),
                  BlocBuilder<TeacherCubit, TeacherState>(
                    builder: (context, state) {
                      if (state is TeacherLoading) {
                        return TextField(
                          controller: _kegiatanC,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Kegiatan:',
                          ),
                        );
                      }
                      if (state is TeacherLoaded) {
                        final activities = state.selectedActivities;

                        final entries = activities.isEmpty
                            ? [
                                const DropdownMenuEntry(
                                    value: '',
                                    label: 'Pilih guru terlebih dahulu')
                              ]
                            : activities
                                .map((a) =>
                                    DropdownMenuEntry(value: a, label: a))
                                .toList();

                        return DropdownMenu<String>(
                          width: width * 0.92,
                          enableFilter: true,
                          requestFocusOnTap: false,
                          initialSelection: _kegiatanC.text,
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: AppColors.tertiary,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black, // <-- warna hint
                            ),
                          ),
                          menuHeight: 200,
                          hintText: 'Kegiatan:',
                          dropdownMenuEntries: entries,
                          onSelected: (value) {
                            _kegiatanC.text = value!;
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
                            cubitAddSchedule.showPicker(widget.day);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_kegiatanC.text.isNotEmpty &&
                              _durasiMulaiC.text.isNotEmpty &&
                              _durasiMulaiC.text.isNotEmpty &&
                              _pelaksanaC.text.isNotEmpty) {
                            cubitCreateSchedule.editActivity(
                                widget.day,
                                widget.index,
                                _pelaksanaC.text,
                                _kegiatanC.text,
                                '${_durasiMulaiC.text} - ${_durasiSelesaiC.text}');
                          }
                          cubitAddSchedule.toggleAdding(widget.day);
                        },
                        child: const Text("Simpan"),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () =>
                            cubitAddSchedule.toggleAdding(widget.day),
                        child: const Text("Batal"),
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
                      cubitAddSchedule.hidePicker(widget.day);
                    },
                    batal: () => cubitAddSchedule.hidePicker(widget.day),
                  ),
                ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: CustomInkWell(
            onTap: () => cubitAddSchedule.toggleAdding(widget.day),
            borderRadius: 12,
            defaultColor: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.schedule.kegiatan,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.schedule.jam,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
