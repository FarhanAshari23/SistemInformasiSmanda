import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/data/models/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardSchedule extends StatefulWidget {
  final String day;
  final int index;
  final DayModel schedule;
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
  final _durasiC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pelaksanaC.text = widget.schedule.pelaksana;
    _kegiatanC.text = widget.schedule.kegiatan;
    _durasiC.text = widget.schedule.jam;
  }

  @override
  void dispose() {
    _pelaksanaC.dispose();
    _kegiatanC.dispose();
    _durasiC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateScheduleCubit>();

    if (_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _pelaksanaC,
            decoration: const InputDecoration(
              hintText: "Nama pengajar: ",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _kegiatanC,
            decoration: const InputDecoration(
              hintText: "Kegiatan: ",
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _durasiC,
            decoration: const InputDecoration(
              hintText: "Durasi: ",
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_kegiatanC.text.isNotEmpty &&
                      _durasiC.text.isNotEmpty &&
                      _pelaksanaC.text.isNotEmpty) {
                    cubit.editActivity(widget.day, widget.index,
                        _pelaksanaC.text, _kegiatanC.text, _durasiC.text);
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

    return GestureDetector(
      onTap: () => setState(() => _isEditing = true),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.inversePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.schedule.kegiatan),
            Text(widget.schedule.jam),
          ],
        ),
      ),
    );
  }
}
