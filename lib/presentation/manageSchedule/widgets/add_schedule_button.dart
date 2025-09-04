import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/create_schedule_cubit.dart';

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
  final _durasiC = TextEditingController();

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

    if (_isAdding) {
      return Column(
        children: [
          TextField(
            controller: _pelaksanaC,
            decoration: const InputDecoration(
              hintText: "Nama pengajar: ",
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _kegiatanC,
            decoration: const InputDecoration(
              hintText: "Kegiatan: ",
            ),
          ),
          const SizedBox(height: 8),
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
                    cubit.addSchedule(widget.day, _pelaksanaC.text,
                        _kegiatanC.text, _durasiC.text);
                  }
                  _kegiatanC.clear();
                  _durasiC.clear();
                  _pelaksanaC.clear();
                  setState(() => _isAdding = false);
                },
                child: const Text("OK"),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  _kegiatanC.clear();
                  _durasiC.clear();
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
