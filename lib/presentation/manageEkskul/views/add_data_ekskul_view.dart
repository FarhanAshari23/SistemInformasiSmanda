import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/ack_ekskul_view.dart';

import '../../../core/configs/theme/app_colors.dart';

class AddDataEkskulView extends StatelessWidget {
  final TextEditingController _namaEkskulC = TextEditingController();
  final TextEditingController _namePembinaC = TextEditingController();
  final TextEditingController _nameKetuaC = TextEditingController();
  final TextEditingController _nameWakilC = TextEditingController();
  final TextEditingController _nameSekretarisC = TextEditingController();
  final TextEditingController _nameBendaharaC = TextEditingController();
  final TextEditingController _deskripsiC = TextEditingController();
  AddDataEkskulView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    List<TextEditingController> listC = [
      _namaEkskulC,
      _namePembinaC,
      _nameKetuaC,
      _nameWakilC,
      _nameSekretarisC,
      _nameBendaharaC,
      _deskripsiC,
    ];
    List<String> hintText = [
      'Nama Ekstrakulikuler:',
      'Nama Pembina:',
      'Nama Ketua',
      'Nama Wakil Ketua',
      'Nama Sekretaris',
      'Nama Bendahara',
      'Deskripsi:'
    ];
    List<int> maxLines = [
      1,
      1,
      1,
      1,
      1,
      1,
      5,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: false),
            SizedBox(height: height * 0.01),
            const Text(
              'TAMBAH EKSKUL',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.55,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return TextField(
                          controller: listC[index],
                          maxLines: maxLines[index],
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: hintText[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: height * 0.01,
                      ),
                      itemCount: listC.length,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(height: height * 0.025),
                  BasicButton(
                    onPressed: () {
                      if (_namePembinaC.text.isEmpty ||
                          _nameKetuaC.text.isEmpty ||
                          _nameWakilC.text.isEmpty ||
                          _nameSekretarisC.text.isEmpty ||
                          _nameBendaharaC.text.isEmpty ||
                          _deskripsiC.text.isEmpty) {
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
                          AckEkskulView(
                            ekskulCreateReq: EkskulModel(
                              namaEkskul: _namaEkskulC.text,
                              namaPembina: _namePembinaC.text,
                              namaKetua: _nameKetuaC.text,
                              namaWakilKetua: _nameWakilC.text,
                              namaSekretaris: _nameSekretarisC.text,
                              namaBendahara: _nameBendaharaC.text,
                              deskripsi: _deskripsiC.text,
                            ),
                          ),
                        );
                      }
                    },
                    title: 'Lanjut',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
