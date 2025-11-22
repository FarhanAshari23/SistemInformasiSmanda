import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widgets/card_ack.dart';

class RegisterAccountDetailView extends StatelessWidget {
  final UserEntity user;
  const RegisterAccountDetailView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> titleList = [
      'Nama',
      'Kelas',
      'NISN',
      'Tanggal Lahir',
      'No HP',
      'Alamat',
      'Gender',
      'Agama',
    ];
    List<dynamic> contentList = [
      user.nama,
      user.kelas,
      user.nisn,
      user.tanggalLahir,
      user.noHP,
      user.alamat,
      user.gender == 1 ? 'Laki-Laki' : 'Perempuan',
      user.agama,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            const Text(
              'DETAIL DATA AKUN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: height * 0.05),
            SizedBox(
              width: double.infinity,
              height: height * 0.4,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  return CardAck(
                    title: titleList[index],
                    content: contentList[index],
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(width: width * 0.01),
                itemCount: titleList.length,
              ),
            ),
            const Spacer(),
            BasicButton(
              onPressed: () => Navigator.pop(context),
              title: "Kembali",
            ),
          ],
        ),
      ),
    );
  }
}
