import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/student_nisn_state.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../domain/usecases/attendance/add_student_attendance.dart';
import '../bloc/student_nisn_cubit.dart';

class ScanQRAttandance extends StatelessWidget {
  const ScanQRAttandance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<StudentsNISNCubit, StudentsNISNState>(
        listener: (context, state) {
          if (state is StudentsNISNLoaded) {
            context.read<ButtonStateCubit>().execute(
                usecase: AddStudentAttendanceUseCase(), params: state.student);
          }
        },
        child: MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              context
                  .read<StudentsNISNCubit>()
                  .displayStudents(params: barcode.rawValue);
            }
          },
        ),
      ),
    );
  }
}
