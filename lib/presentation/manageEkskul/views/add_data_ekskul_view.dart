import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/searchbar/search_teachers_views.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/ack_ekskul_view.dart';
import 'package:new_sistem_informasi_smanda/common/widget/searchbar/search_students_view.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../domain/entities/ekskul/ekskul.dart';

class AddDataEkskulView extends StatefulWidget {
  const AddDataEkskulView({super.key});

  @override
  State<AddDataEkskulView> createState() => _AddDataEkskulViewState();
}

class _AddDataEkskulViewState extends State<AddDataEkskulView> {
  final TextEditingController _namaEkskulC = TextEditingController();
  final TextEditingController _namePembinaC = TextEditingController();
  final TextEditingController _nameKetuaC = TextEditingController();
  final TextEditingController _nameWakilC = TextEditingController();
  final TextEditingController _nameSekretarisC = TextEditingController();
  final TextEditingController _nameBendaharaC = TextEditingController();
  final TextEditingController _deskripsiC = TextEditingController();

  TeacherEntity? _selectedPembina;
  UserEntity? _selectedKetua;
  UserEntity? _selectedWakil;
  UserEntity? _selectedSekretaris;
  UserEntity? _selectedBendahara;

  @override
  void dispose() {
    super.dispose();
    _namaEkskulC.dispose();
    _namePembinaC.dispose();
    _nameKetuaC.dispose();
    _nameWakilC.dispose();
    _nameSekretarisC.dispose();
    _nameBendaharaC.dispose();
    _deskripsiC.dispose();
  }

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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  if (index == 0 || index == 6) {
                    return TextField(
                      controller: listC[index],
                      maxLines: maxLines[index],
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: hintText[index],
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }
                  return TextField(
                    readOnly: true,
                    controller: listC[index],
                    maxLines: maxLines[index],
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: hintText[index],
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () async {
                      final route = (index == 1)
                          ? MaterialPageRoute(
                              builder: (_) => const SearchTeachersViews())
                          : MaterialPageRoute(
                              builder: (_) => const SearchStudentsView());

                      final result = await Navigator.push(context, route);

                      if (result != null) {
                        setState(() {
                          if (index == 1 && result is TeacherEntity) {
                            _selectedPembina = result;
                            _namePembinaC.text = result.nama;
                          } else if (result is UserEntity) {
                            switch (index) {
                              case 2:
                                _selectedKetua = result;
                                _nameKetuaC.text = result.nama ?? '';
                                break;
                              case 3:
                                _selectedWakil = result;
                                _nameWakilC.text = result.nama ?? '';
                                break;
                              case 4:
                                _selectedSekretaris = result;
                                _nameSekretarisC.text = result.nama ?? '';
                                break;
                              case 5:
                                _selectedBendahara = result;
                                _nameBendaharaC.text = result.nama ?? '';
                                break;
                            }
                          }
                        });
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: height * 0.01,
                ),
                itemCount: listC.length,
              ),
            ),
            BasicButton(
              onPressed: () {
                if (_namaEkskulC.text.isEmpty ||
                    _selectedPembina == null ||
                    _selectedKetua == null ||
                    _selectedWakil == null ||
                    _selectedSekretaris == null ||
                    _selectedBendahara == null ||
                    _deskripsiC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Tolong isi semua kolom yang tersedia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  FocusScope.of(context).unfocus();
                  AppNavigator.push(
                    context,
                    AckEkskulView(
                      ekskulCreateReq: EkskulEntity(
                        namaEkskul: _namaEkskulC.text,
                        pembina: _selectedPembina!,
                        ketua: _selectedKetua!,
                        wakilKetua: _selectedWakil!,
                        sekretaris: _selectedSekretaris!,
                        bendahara: _selectedBendahara!,
                        deskripsi: _deskripsiC.text,
                        anggota: [],
                      ),
                    ),
                  );
                }
              },
              title: 'Lanjut',
            )
          ],
        ),
      ),
    );
  }
}
