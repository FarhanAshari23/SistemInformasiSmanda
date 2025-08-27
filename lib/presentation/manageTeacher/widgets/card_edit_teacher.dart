// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/delete_teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/update_teacher.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';

class CardEditTeacher extends StatelessWidget {
  final TeacherEntity teacher;
  const CardEditTeacher({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    TextEditingController _nameC = TextEditingController(text: teacher.nama);
    TextEditingController _nipC = TextEditingController(text: teacher.nip);
    TextEditingController _mengajarC =
        TextEditingController(text: teacher.mengajar);
    TextEditingController _tanggalC =
        TextEditingController(text: teacher.tanggalLahir);
    TextEditingController _waliKelasC =
        TextEditingController(text: teacher.waliKelas);
    TextEditingController _jabatanC =
        TextEditingController(text: teacher.jabatan);
    List<String> namaHint = [
      'Nama: ',
      'NIP: ',
      'Mengajar: ',
      'Tanggal Lahir: ',
      'Wali Kelas: ',
      'Jabatan Tambahan: ',
    ];
    List<TextEditingController> listController = [
      _nameC,
      _nipC,
      _mengajarC,
      _tanggalC,
      _waliKelasC,
      _jabatanC,
    ];
    List<int> maxLines = [
      1,
      1,
      1,
      1,
      1,
      2,
    ];
    return Container(
      width: width * 0.7,
      height: bodyHeight * 0.175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Container(
                  width: width * 0.25,
                  height: bodyHeight * 0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage(AppImages.guru),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.465,
                        height: bodyHeight * 0.06,
                        child: Text(
                          teacher.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.4,
                        height: bodyHeight * 0.04,
                        child: Text(
                          teacher.nip,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: PopupMenuButton(
              onSelected: (String value) {
                if (value == 'Edit') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: AppColors.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: bodyHeight * 0.695,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Ubah Data Guru',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: bodyHeight * 0.02),
                                  SizedBox(
                                    width: width * 0.6,
                                    height: bodyHeight * 0.5,
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return TextField(
                                          maxLines: maxLines[index],
                                          controller: listController[index],
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: namaHint[index],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: bodyHeight * 0.01,
                                      ),
                                      itemCount: namaHint.length,
                                    ),
                                  ),
                                  SizedBox(height: bodyHeight * 0.01),
                                  GestureDetector(
                                    onTap: () async {
                                      var result =
                                          await sl<UpdateTeacherUsecase>().call(
                                        params: TeacherEntity(
                                          nama: _nameC.text,
                                          mengajar: _mengajarC.text,
                                          nip: _nipC.text,
                                          tanggalLahir: _tanggalC.text,
                                          waliKelas: _waliKelasC.text,
                                          jabatan: _jabatanC.text,
                                        ),
                                      );
                                      result.fold(
                                        (error) {
                                          var snackbar = const SnackBar(
                                            content:
                                                Text("Gagal Mengubah Data"),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                        },
                                        (r) {
                                          var snackbar = const SnackBar(
                                            content:
                                                Text("Data Berhasil Diubah"),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: width * 0.3,
                                      height: bodyHeight * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.secondary,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Ubah',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.inversePrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (value == 'Hapus') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: AppColors.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: width * 0.7,
                          height: bodyHeight * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.6,
                                height: bodyHeight * 0.3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImages.splashDelete),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Apakah anda yakin ingin menghapus data ${teacher.nama}?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: bodyHeight * 0.02),
                              BasicButton(
                                onPressed: () async {
                                  var delete = await sl<DeleteTeacherUsecase>()
                                      .call(params: teacher.nip);
                                  return delete.fold(
                                    (error) {
                                      var snackbar = const SnackBar(
                                        content: Text(
                                            "Gagal Menghapus Data Guru, Coba Lagi"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    (r) {
                                      var snackbar = const SnackBar(
                                        content: Text("Data Berhasil Dihapus"),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                title: 'Hapus',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Hapus',
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ),
                ];
              },
              child: Container(
                width: width * 0.1,
                height: bodyHeight * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
