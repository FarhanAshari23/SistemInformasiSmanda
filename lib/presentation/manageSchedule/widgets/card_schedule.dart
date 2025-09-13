import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/divided_range_time.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';

import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../../../common/bloc/activities/get_activities_state.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/durasi_cubit.dart';

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
  bool _isEditing = false;
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
    final cubit = context.read<CreateScheduleCubit>();
    final width = MediaQuery.of(context).size.width;

    if (_isEditing) {
      return Column(
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
                return DropdownMenu<String>(
                  width: width * 0.92,
                  enableFilter: true,
                  requestFocusOnTap: true,
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
                  dropdownMenuEntries: state.activities.map((doc) {
                    final nama = doc.name;
                    return DropdownMenuEntry(
                      value: nama,
                      label: nama,
                    );
                  }).toList(),
                  onSelected: (value) {
                    context.read<GetActivitiesCubit>().selectItem(value);
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
                child: BlocBuilder<DurasiCubit, String?>(
                  builder: (context, selectedValue) {
                    final cubit = context.read<DurasiCubit>();
                    return DropdownMenu<String>(
                      width: width * 0.92,
                      initialSelection: _durasiMulaiC.text,
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
                      hintText: "Jam mulai:",
                      dropdownMenuEntries: cubit.times.map((doc) {
                        return DropdownMenuEntry(
                          value: doc,
                          label: doc,
                        );
                      }).toList(),
                      onSelected: (value) {
                        final cubit = context.read<DurasiCubit>();
                        if (value != null) {
                          cubit.selectItem(value);
                          _durasiMulaiC.text = value;
                        }
                      },
                    );
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
                child: BlocBuilder<DurasiCubit, String?>(
                  builder: (context, selectedValue) {
                    final cubit = context.read<DurasiCubit>();
                    return DropdownMenu<String>(
                      width: width * 0.92,
                      initialSelection: _durasiSelesaiC.text,
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
                      hintText: "Jam mulai:",
                      dropdownMenuEntries: cubit.times.map((doc) {
                        return DropdownMenuEntry(
                          value: doc,
                          label: doc,
                        );
                      }).toList(),
                      onSelected: (value) {
                        final cubit = context.read<DurasiCubit>();
                        if (value != null) {
                          cubit.selectItem(value);
                          _durasiSelesaiC.text = value;
                        }
                      },
                    );
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
                    cubit.editActivity(
                        widget.day,
                        widget.index,
                        _pelaksanaC.text,
                        _kegiatanC.text,
                        '${_durasiMulaiC.text} - ${_durasiSelesaiC.text}');
                  }
                  setState(() => _isEditing = false);
                },
                child: const Text("Simpan"),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _isEditing = false),
                child: const Text("Batal"),
              )
            ],
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: CustomInkWell(
        onTap: () => setState(() => _isEditing = true),
        borderRadius: 12,
        defaultColor: AppColors.inversePrimary,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.schedule.kegiatan),
              Text(widget.schedule.jam),
            ],
          ),
        ),
      ),
    );
  }
}
