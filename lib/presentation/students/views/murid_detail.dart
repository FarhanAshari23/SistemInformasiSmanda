import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/widgets/card_detail.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/helper/display_image.dart';

class MuridDetail extends StatelessWidget {
  final UserEntity user;
  const MuridDetail({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pagecontroller = PageController();
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: bodyHeight,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: bodyHeight * 0.51,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: bodyHeight,
                            color: const Color(0xff2D66BD),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: bodyHeight,
                              imageUrl: DisplayImage.displayImageStudent(
                                user.nama!,
                                user.nisn!,
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                user.gender == 1
                                    ? AppImages.boyStudent
                                    : AppImages.girlStudent,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primary,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: AppColors.inversePrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: bodyHeight * 0.45,
                      child: Container(
                        width: width,
                        height: bodyHeight * 0.6,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          color: AppColors.inversePrimary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 32),
                          child: Column(
                            children: [
                              Text(
                                user.nama!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                user.kelas!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: bodyHeight * 0.02),
                              SizedBox(
                                width: double.infinity,
                                height: bodyHeight * 0.3,
                                child: PageView(
                                  controller: pagecontroller,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: CardDetailSiswa(
                                            title: 'Tanggal Lahir',
                                            content: user.tanggalLahir!,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: CardDetailSiswa(
                                            title: 'Alamat',
                                            content: user.alamat!,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: CardDetailSiswa(
                                              title: 'Agama',
                                              content: user.agama!,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: CardDetailSiswa(
                                              title: 'Jenis Kelamin',
                                              content: user.gender! == 1
                                                  ? 'Laki-laki'
                                                  : 'Perempuan',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: CardDetailSiswa(
                                              title: 'No HP',
                                              content: user.noHP!,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: CardDetailSiswa(
                                              title: 'Ekskul',
                                              content: user.ekskul!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: bodyHeight * 0.03),
                              SmoothPageIndicator(
                                controller: pagecontroller,
                                count: 3,
                                effect: const ExpandingDotsEffect(
                                  activeDotColor: AppColors.primary,
                                  dotColor: AppColors.secondary,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider getImageProvider(String imageUrl, String assetPath) {
    try {
      Uri.parse(imageUrl); // Cek apakah URL valid
      return CachedNetworkImageProvider(imageUrl);
    } catch (e) {
      return AssetImage(assetPath);
    }
  }
}
