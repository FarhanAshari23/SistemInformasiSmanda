import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';

import '../../../common/helper/display_image.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../students/widgets/card_detail.dart';

class StaffDetail extends StatelessWidget {
  final TeacherEntity teachers;
  const StaffDetail({
    super.key,
    required this.teachers,
  });

  @override
  Widget build(BuildContext context) {
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
                    NetworkPhoto(
                      width: double.infinity,
                      height: bodyHeight * 0.49,
                      fallbackAsset: teachers.gender == 1
                          ? AppImages.tendikLaki
                          : AppImages.tendikPerempuan,
                      imageUrl: DisplayImage.displayImageTeacher(
                        teachers.nama,
                        teachers.nip != '-'
                            ? teachers.nip
                            : teachers.tanggalLahir,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CardDetailSiswa(
                                        title: 'Tanggal Lahir',
                                        content: teachers.tanggalLahir,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: CardDetailSiswa(
                                        title: 'Pekerjaan',
                                        content: teachers.mengajar,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
