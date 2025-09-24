import 'package:flutter/material.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/usecases/ekskul/update_ekskul.dart';
import '../../../service_locator.dart';
import 'list_teacher_view.dart';
import 'search_students_view.dart';

class EditEkskulDetail extends StatefulWidget {
  final EkskulEntity ekskul;
  const EditEkskulDetail({
    super.key,
    required this.ekskul,
  });

  @override
  State<EditEkskulDetail> createState() => _EditEkskulDetailState();
}

class _EditEkskulDetailState extends State<EditEkskulDetail> {
  late TextEditingController _nameEkskulC;
  late TextEditingController _namePembinaC;
  late TextEditingController _nameKetuaC;
  late TextEditingController _nameWakilC;
  late TextEditingController _nameSekretarisC;
  late TextEditingController _nameBendaharaC;
  late TextEditingController _deskripsiC;

  @override
  void initState() {
    super.initState();
    _nameEkskulC = TextEditingController(text: widget.ekskul.namaEkskul);
    _namePembinaC = TextEditingController(text: widget.ekskul.namaPembina);
    _nameKetuaC = TextEditingController(text: widget.ekskul.namaKetua);
    _nameWakilC = TextEditingController(text: widget.ekskul.namaWakilKetua);
    _nameSekretarisC =
        TextEditingController(text: widget.ekskul.namaSekretaris);
    _nameBendaharaC = TextEditingController(text: widget.ekskul.namaBendahara);
    _deskripsiC = TextEditingController(text: widget.ekskul.deskripsi);
  }

  @override
  void dispose() {
    super.dispose();
    _nameEkskulC.dispose();
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
      _nameEkskulC,
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
            const Text(
              'Data mana yang ingin anda ubah?',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: height * 0.03),
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
                              builder: (_) => const ListTeacherView())
                          : MaterialPageRoute(
                              builder: (_) => const SearchStudentsView());

                      final result = await Navigator.push(context, route);

                      if (result != null) {
                        setState(() {
                          // isi textfield sesuai item yang ditekan
                          listC[index].text = result.toString();
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
              onPressed: () async {
                if (_namePembinaC.text.isEmpty ||
                    _nameKetuaC.text.isEmpty ||
                    _nameWakilC.text.isEmpty ||
                    _nameSekretarisC.text.isEmpty ||
                    _nameBendaharaC.text.isEmpty ||
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
                  var result = await sl<UpdateEkskulUsecase>().call(
                      params: EkskulEntity(
                    namaEkskul: _nameEkskulC.text,
                    namaPembina: _namePembinaC.text,
                    namaKetua: _nameKetuaC.text,
                    namaWakilKetua: _nameWakilC.text,
                    namaSekretaris: _nameSekretarisC.text,
                    namaBendahara: _nameBendaharaC.text,
                    deskripsi: _deskripsiC.text,
                    anggota: [],
                  ));
                  result.fold(
                    (error) {
                      var snackbar = const SnackBar(
                        content: Text("Gagal Mengubah Data"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    (r) {
                      var snackbar = const SnackBar(
                        content: Text("Data Berhasil Diubah"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.pop(context);
                    },
                  );
                }
              },
              title: 'Ubah',
            ),
          ],
        ),
      ),
    );
  }
}
