import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../bloc/student_nisn_cubit.dart';

class ScanQRAttandance extends StatelessWidget {
  const ScanQRAttandance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
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
    );
  }
}
