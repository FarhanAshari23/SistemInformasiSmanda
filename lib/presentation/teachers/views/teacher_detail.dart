import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../students/widgets/card_detail.dart';

class TeacherDetail extends StatelessWidget {
  final TeacherEntity teachers;
  const TeacherDetail({
    super.key,
    required this.teachers,
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
                    Container(
                      width: double.infinity,
                      height: bodyHeight * 0.51,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            AppImages.guru,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: bodyHeight,
                        imageUrl: DisplayImage.displayImageTeacher(
                            teachers.nama, teachers.nip),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset(AppImages.guru),
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
                                teachers.nama,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                teachers.nip,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CardDetailSiswa(
                                          title: 'Tanggal Lahir',
                                          content: teachers.tanggalLahir,
                                        ),
                                        CardDetailSiswa(
                                          title: 'Mengajar',
                                          content: teachers.mengajar,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CardDetailSiswa(
                                            title: 'Wali\nKelas',
                                            content: teachers.waliKelas,
                                          ),
                                          CardDetailSiswa(
                                            title: 'Tanggal Jabatan',
                                            content: teachers.jabatan,
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
                                count: 2,
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
}
