import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrNisn extends StatelessWidget {
  const ScanQrNisn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final String? nisn = barcodes.first.rawValue;
          if (nisn != null) {
            Navigator.pop(context, nisn);
          }
        },
      ),
    );
  }
}
