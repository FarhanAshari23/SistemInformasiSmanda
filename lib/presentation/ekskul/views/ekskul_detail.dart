import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_anggota_ekskul.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

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
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: true),
            Text(
              ekskul.namaEkskul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CardAnggotaEkskul(
                    name: ekskul.namaPembina,
                    jabatan: 'Pembina',
                    namaEkskul: ekskul.namaEkskul,
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.235,
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
                  SizedBox(height: height * 0.02),
                  Container(
                    width: double.infinity,
                    height: height * 0.235,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Text(
                            ekskul.deskripsi,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.inversePrimary,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
