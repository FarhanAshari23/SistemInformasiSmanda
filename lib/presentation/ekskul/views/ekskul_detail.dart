import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_anggota_ekskul.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../../../common/widget/inkwell/custom_inkwell.dart';

class EkskulDetail extends StatelessWidget {
  final EkskulEntity ekskul;
  const EkskulDetail({super.key, required this.ekskul});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> jabatan = ['Ketua', 'Wakil Ketua', 'Sekretaris', 'Bendahara'];
    List<String> nama = [
      ekskul.namaKetua,
      ekskul.namaWakilKetua,
      ekskul.namaSekretaris,
      ekskul.namaBendahara,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: true),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CustomInkWell(
                        borderRadius: 8,
                        defaultColor: AppColors.primary,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Deskripsi:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      ekskul.deskripsi,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      ekskul.namaEkskul,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  Center(
                    child: CardAnggotaEkskul(
                      name: ekskul.namaPembina,
                      jabatan: 'Pembina',
                      namaEkskul: ekskul.namaEkskul,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: height * 0.25,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CardAnggotaEkskul(
                          namaEkskul: ekskul.namaEkskul,
                          name: nama[index],
                          jabatan: jabatan[index],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.04),
                      itemCount: 4,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Anggota:',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ekskul.anggota.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.emptyRegistrationChara,
                                width: 120,
                                height: 120,
                              ),
                              const Text(
                                'Belum ada anggota',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            final anggota = ekskul.anggota[index];
                            return Container(
                              width: 20,
                              height: 20,
                              color: Colors.white,
                              child: Text(anggota.nama),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: ekskul.anggota.length,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
