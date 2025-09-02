import 'package:flutter/material.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> {
  final TextEditingController _kelasC = TextEditingController();

  @override
  void dispose() {
    _kelasC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Masukan informasi yang sesuai pada kolom berikut:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              controller: _kelasC,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "Nama Kelas:",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
