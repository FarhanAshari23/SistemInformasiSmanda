import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/delete_ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/update_ekskul.dart';

import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';

class CardEkskulEdit extends StatelessWidget {
  final EkskulEntity ekskul;
  const CardEkskulEdit({
    super.key,
    required this.ekskul,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameC =
        TextEditingController(text: ekskul.namaEkskul);
    TextEditingController ketuaC =
        TextEditingController(text: ekskul.namaKetua);
    TextEditingController pembinaC =
        TextEditingController(text: ekskul.namaPembina);
    TextEditingController wakilC =
        TextEditingController(text: ekskul.namaWakilKetua);
    TextEditingController sekretarisC =
        TextEditingController(text: ekskul.namaSekretaris);
    TextEditingController bendaharaC =
        TextEditingController(text: ekskul.namaBendahara);
    TextEditingController deskripsiC =
        TextEditingController(text: ekskul.deskripsi);
    List<String> hintText = [
      "Nama Ekskul",
      "Nama Pembina",
      "Nama Ketua",
      "Nama Wakil Ketua",
      "Nama Sekretaris",
      "Nama Bendahara",
      "Deskripsi",
    ];
    List<TextEditingController> controllers = [
      nameC,
      pembinaC,
      ketuaC,
      wakilC,
      sekretarisC,
      bendaharaC,
      deskripsiC,
    ];
    List<int> maxLines = [
      1,
      1,
      1,
      1,
      1,
      1,
      4,
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4,
      height: height * 0.275,
      color: AppColors.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            height: height * 0.19,
            child: CachedNetworkImage(
              imageUrl: DisplayImage.displayImageEkskul(ekskul.namaEkskul),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  Image.asset(AppImages.splashEkskul),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            ekskul.namaEkskul,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.inversePrimary,
            ),
            textAlign: TextAlign.center,
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
                            height: height * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Ubah Data Ekskul',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  SizedBox(
                                    width: width * 0.6,
                                    height: height * 0.5,
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return TextField(
                                          maxLines: maxLines[index],
                                          controller: controllers[index],
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: hintText[index],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: height * 0.01,
                                      ),
                                      itemCount: hintText.length,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  GestureDetector(
                                    onTap: () async {
                                      var result =
                                          await sl<UpdateEkskulUsecase>().call(
                                              params: EkskulEntity(
                                        namaEkskul: nameC.text,
                                        namaPembina: pembinaC.text,
                                        namaKetua: ketuaC.text,
                                        namaWakilKetua: wakilC.text,
                                        namaSekretaris: sekretarisC.text,
                                        namaBendahara: bendaharaC.text,
                                        deskripsi: deskripsiC.text,
                                      ));
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
                                      height: height * 0.08,
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
                          height: height * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.6,
                                height: height * 0.3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImages.splashDelete),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Apakah anda yakin ingin menghapus data ${ekskul.namaEkskul}?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: height * 0.02),
                              BasicButton(
                                onPressed: () async {
                                  var delete = await sl<DeleteEkskulUsecase>()
                                      .call(params: ekskul.namaEkskul);
                                  return delete.fold(
                                    (error) {
                                      var snackbar = const SnackBar(
                                        content: Text(
                                            "Gagal Menghapus Ekskul, Coba Lagi"),
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
                width: width * 0.085,
                height: height * 0.04,
                color: AppColors.primary,
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
