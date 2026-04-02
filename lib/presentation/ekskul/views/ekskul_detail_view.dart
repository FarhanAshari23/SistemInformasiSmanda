import 'package:flutter/material.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/card_anggota.dart';
import '../../../common/widget/card/card_anggota_ekskul.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/entities/ekskul/member.dart';
import '../../../common/widget/detail/murid_detail.dart';

class EkskulDetail extends StatelessWidget {
  final EkskulEntity ekskul;
  const EkskulDetail({super.key, required this.ekskul});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> jabatan = ['Ketua', 'Wakil Ketua', 'Sekretaris', 'Bendahara'];
    List<MemberEntity> jabatans = [
      ekskul.members!.where((element) => element.role == "Ketua").first,
      ekskul.members!.where((element) => element.role == "Wakil Ketua").first,
      ekskul.members!.where((element) => element.role == "Sekretaris").first,
      ekskul.members!.where((element) => element.role == "Bendahara").first,
    ];
    List<MemberEntity> anggotas =
        ekskul.members!.where((element) => element.role == "Anggota").toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BasicAppbar(isBackViewed: true),
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
                                        ekskul.description ?? '',
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
                      ekskul.nameEkskul ?? '',
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
                      pembina: ekskul.advisor,
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
                          murid: jabatans[index],
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
                  anggotas.isEmpty
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
                            final anggota = anggotas[index];
                            return CardAnggota(
                              onTap: () => AppNavigator.push(
                                context,
                                MuridDetail(userId: anggota.id ?? 0),
                              ),
                              murid: anggota,
                              title: anggota.name ?? '',
                              desc: anggota.nisn ?? '',
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: anggotas.length,
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
