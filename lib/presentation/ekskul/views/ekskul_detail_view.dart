import 'package:flutter/material.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/card_anggota.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/entities/ekskul/member.dart';
import '../../../common/widget/detail/murid_detail.dart';
import '../widgets/card_pembina.dart';
import '../widgets/card_pengurus.dart';

class EkskulDetail extends StatelessWidget {
  final EkskulEntity ekskul;
  const EkskulDetail({super.key, required this.ekskul});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: NetworkPhoto(
                                    height: height * 0.125,
                                    width: height * 0.125,
                                    imageUrl: DisplayImage.displayImageEkskul(
                                        ekskul.picture ?? ''),
                                    fallbackAsset: AppImages.eskul,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    ekskul.nameEkskul ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomInkWell(
                              defaultColor: AppColors.secondary,
                              borderRadius: 8,
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                              ),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "PEMBINA",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                      child: Row(
                    mainAxisAlignment: ekskul.advisors!.length > 1
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: List.generate(
                      ekskul.advisors!.length,
                      (index) {
                        return CardPembina(
                          ekskul: ekskul,
                          index: index,
                        );
                      },
                    ),
                  )),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "PENGURUS INTI",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                      children: List.generate(
                    2,
                    (index) {
                      return CardPengurus(
                        member: jabatans[index],
                        background: AppColors.secondary,
                        text: AppColors.inversePrimary,
                      );
                    },
                  )),
                  const SizedBox(height: 8),
                  Row(
                      children: List.generate(
                    2,
                    (index) {
                      return CardPengurus(
                        member: jabatans[index + 2],
                        background: AppColors.inversePrimary,
                        text: AppColors.primary,
                      );
                    },
                  )),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "ANGGOTA",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
