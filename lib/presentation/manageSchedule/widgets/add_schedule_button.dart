import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/durasi_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_activities_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_activities_state.dart';

import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/bloc/teacher/teacher_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddScheduleButton extends StatefulWidget {
  final String day;
  const AddScheduleButton({super.key, required this.day});

  @override
  State<AddScheduleButton> createState() => _AddScheduleButtonState();
}

class _AddScheduleButtonState extends State<AddScheduleButton> {
  bool _isAdding = false;
  final _pelaksanaC = TextEditingController();
  final _kegiatanC = TextEditingController();
  final _durasiMulaiC = TextEditingController();
  final _durasiSelesaiC = TextEditingController();

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
    double width = MediaQuery.of(context).size.width;

    if (_isAdding) {
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
                  hintText: 'Pelaksana:',
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
                    cubit.addSchedule(
                        widget.day,
                        _pelaksanaC.text,
                        _kegiatanC.text,
                        '${_durasiMulaiC.text} - ${_durasiSelesaiC.text}');
                  }
                  _kegiatanC.clear();
                  _durasiMulaiC.clear();
                  _durasiSelesaiC.clear();
                  _pelaksanaC.clear();
                  setState(() => _isAdding = false);
                },
                child: const Text("OK"),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _kegiatanC.clear();
                  _durasiMulaiC.clear();
                  _durasiSelesaiC.clear();
                  _pelaksanaC.clear();
                  setState(() => _isAdding = false);
                },
                child: const Text("Batal"),
              )
            ],
          )
        ],
      );
    }

    return TextButton.icon(
      onPressed: () => setState(() => _isAdding = true),
      icon: const Icon(Icons.add),
      label: const Text("Tambah aktivitas"),
    );
  }
}
