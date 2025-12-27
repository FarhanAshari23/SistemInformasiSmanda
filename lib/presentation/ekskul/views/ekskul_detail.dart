import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_anggota_ekskul.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/murid_detail.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/card/card_anggota.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../domain/entities/auth/user.dart';

class EkskulDetail extends StatelessWidget {
  final EkskulEntity ekskul;
  const EkskulDetail({super.key, required this.ekskul});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> jabatan = ['Ketua', 'Wakil Ketua', 'Sekretaris', 'Bendahara'];
    List<UserEntity> anggota = [
      ekskul.ketua,
      ekskul.wakilKetua,
      ekskul.sekretaris,
      ekskul.bendahara,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            isScrollControlled: true,
                            builder: (context) {
                              return SafeArea(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      pembina: ekskul.pembina,
                      jabatan: 'Pembina',
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    height: height * 0.25,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CardAnggotaEkskul(
                          murid: anggota[index],
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
                  const SizedBox(height: 4),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          itemBuilder: (context, index) {
                            final anggota = ekskul.anggota[index];
                            return CardAnggota(
                              onTap: () => AppNavigator.push(
                                context,
                                MuridDetail(user: anggota),
                              ),
                              murid: anggota,
                              title: anggota.nama ?? '',
                              desc: anggota.nisn ?? '',
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
