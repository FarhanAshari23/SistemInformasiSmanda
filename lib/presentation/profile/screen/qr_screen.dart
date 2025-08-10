import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';

class QrScreen extends StatelessWidget {
  final String qrCodeData;
  const QrScreen({
    super.key,
    required this.qrCodeData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: qrCodeData,
            width: 200,
            height: 200,
          ),
          const Text(
            'Silakan tunjukkan QR ini untuk melakukan absen',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
