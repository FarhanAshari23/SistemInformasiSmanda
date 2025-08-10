import 'package:flutter/material.dart';

import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/ack_add_teacher_view.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddTeacherView extends StatelessWidget {
  AddTeacherView({
    super.key,
  });
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _mengajarC = TextEditingController();
  final TextEditingController _nipC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _waliKelasC = TextEditingController();
  final TextEditingController _jabatanC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> hinttext = [
      'nama:',
      'mengajar:',
      'NIP:',
      'Tanggal Lahir:',
      'Wali Kelas:',
      'Jabatan Tambahan:'
    ];
    List<TextEditingController> controller = [
      _namaC,
      _mengajarC,
      _nipC,
      _tanggalC,
      _waliKelasC,
      _jabatanC,
    ];
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            const Text(
              'TAMBAH DATA GURU',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.04),
                  const Text(
                    'Masukan informasi yang sesuai pada kolom berikut:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.45,
                    child: ListView.separated(
                      itemBuilder: (context, index) => TextField(
                        controller: controller[index],
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: hinttext[index],
                        ),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: height * 0.01,
                      ),
                      itemCount: hinttext.length,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '*Beri tanda "-" jika guru tidak memiliki baik wali kelas maupun jabatan ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
            BasicButton(
              onPressed: () {
                if (_namaC.text.isEmpty ||
                    _nipC.text.isEmpty ||
                    _mengajarC.text.isEmpty ||
                    _tanggalC.text.isEmpty ||
                    _waliKelasC.text.isEmpty ||
                    _jabatanC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Please fill all the textfield',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  AppNavigator.push(
                    context,
                    AckAddTeacherView(
                      teacherCreationReq: TeacherModel(
                        nama: _namaC.text,
                        mengajar: _mengajarC.text,
                        nip: _nipC.text,
                        tanggalLahir: _tanggalC.text,
                        waliKelas: _waliKelasC.text,
                        jabatan: _jabatanC.text,
                      ),
                    ),
                  );
                }
              },
              title: 'Lanjut',
            ),
          ],
        ),
      ),
    );
  }
}
