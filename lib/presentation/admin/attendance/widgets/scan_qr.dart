import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/student_nisn_state.dart';

import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../domain/entities/attandance/attendance_student.dart';
import '../../../../domain/usecases/attendance/add_student_attendance.dart';
import '../../../profile/bloc/get_distace_state.dart';
import '../../../profile/bloc/get_distance_cubit.dart';
import '../../../profile/bloc/student_nisn_cubit.dart';

class ScanQRAttandance extends StatelessWidget {
  const ScanQRAttandance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<StudentsNISNCubit, StudentsNISNState>(
            listener: (context, state) {
              if (state is StudentsNISNLoaded) {
                context.read<ButtonStateCubit>().execute(
                      usecase: AddStudentAttendanceUseCase(),
                      params: AttendanceStudentEntity(
                        studentId: state.student.id,
                        status: "Hadir",
                      ),
                    );
              }
            },
          ),
          BlocListener<GetDistanceCubit, GetDistanceState>(
            listener: (context, state) {
              if (state is GetDistanceLoading) {
                var snackbar = const SnackBar(
                  content: Text("Sedang mengecek lokasi..."),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          ),
        ],
        child: MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
          ),
          onDetect: (capture) async {
            final distanceCubit = context.read<GetDistanceCubit>();
            await distanceCubit.getDistance();
            if (!context.mounted) return;

            final state = distanceCubit.state;
            if (state is GetDistanceLoaded && !state.isNear) return;
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
