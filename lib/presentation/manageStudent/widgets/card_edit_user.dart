// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/update_user.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/delete_student.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/update_user.dart';

import '../../../common/helper/display_image.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';

class CardEditUser extends StatelessWidget {
  final UserEntity student;
  final Widget backPage;
  const CardEditUser({
    super.key,
    required this.student,
    required this.backPage,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    TextEditingController _nameC = TextEditingController(text: student.nama);
    TextEditingController _kelasC = TextEditingController(text: student.kelas);
    TextEditingController _nisnC = TextEditingController(text: student.nisn);
    TextEditingController _tanggalC =
        TextEditingController(text: student.tanggalLahir);
    TextEditingController _alamatC =
        TextEditingController(text: student.alamat);
    TextEditingController _noHPC = TextEditingController(text: student.noHP);
    TextEditingController _ekskulC =
        TextEditingController(text: student.ekskul);
    TextEditingController _agamaC = TextEditingController(text: student.agama);
    List<String> namaHint = [
      'Nama: ',
      'Kelas: ',
      'NISN: ',
      'Tanggal Lahir: ',
      'No HP: ',
      'Ekskul: ',
      'Agama: ',
      'Alamat: ',
    ];
    List<TextEditingController> listController = [
      _nameC,
      _kelasC,
      _nisnC,
      _tanggalC,
      _noHPC,
      _ekskulC,
      _agamaC,
      _alamatC,
    ];
    List<int> maxLines = [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      3,
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
                SizedBox(
                  width: width * 0.235,
                  height: bodyHeight * 0.14,
                  child: CachedNetworkImage(
                    imageUrl: DisplayImage.displayImageStudent(
                      student.nama!,
                      student.nisn!,
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      student.gender == 1
                          ? AppImages.boyStudent
                          : AppImages.girlStudent,
                    ),
                    fit: BoxFit.fill,
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
                          student.nama!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: bodyHeight * 0.01),
                      Text(
                        student.nisn!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
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
                            height: bodyHeight * 0.75,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Ubah Data Siswa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: bodyHeight * 0.02),
                                  SizedBox(
                                    width: width * 0.6,
                                    height: bodyHeight * 0.55,
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
                                          await sl<UpdateStudentUsecase>().call(
                                        params: UpdateUserReq(
                                          nama: _nameC.text,
                                          kelas: _kelasC.text,
                                          nisn: _nisnC.text,
                                          tanggalLahir: _tanggalC.text,
                                          noHp: _noHPC.text,
                                          alamat: _alamatC.text,
                                          ekskul: _ekskulC.text,
                                          agama: _agamaC.text,
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
                                          AppNavigator.push(context, backPage);
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
                                'Apakah anda yakin ingin menghapus data ${student.nama}?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: bodyHeight * 0.02),
                              BasicButton(
                                onPressed: () async {
                                  var delete = await sl<DeleteStudentUsecase>()
                                      .call(params: student.nisn);
                                  return delete.fold(
                                    (error) {
                                      var snackbar = const SnackBar(
                                        content: Text(
                                            "Gagal Menghapus Murid, Coba Lagi"),
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
                                      AppNavigator.push(context, backPage);
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
