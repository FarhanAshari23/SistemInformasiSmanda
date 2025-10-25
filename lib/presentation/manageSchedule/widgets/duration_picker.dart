import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/widget/button/basic_button.dart';

class DurationPicker extends StatelessWidget {
  final double width;
  final double height;
  final void Function(DateTime) onDateTimeChanged;
  final void Function() simpan;
  final void Function() batal;
  const DurationPicker({
    super.key,
    required this.width,
    required this.height,
    required this.onDateTimeChanged,
    required this.simpan,
    required this.batal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width * 0.8,
          height: height * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 24),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: onDateTimeChanged,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: BasicButton(
                onPressed: simpan,
                title: 'Simpan',
              ),
            ),
            Expanded(
              child: BasicButton(
                onPressed: batal,
                title: 'Batal',
              ),
            ),
          ],
        )
      ],
    );
  }
}
