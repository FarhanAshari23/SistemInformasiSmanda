import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../helper/display_image.dart';
import '../detail/teacher_detail.dart';
import '../photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';

class CardOrganization extends StatelessWidget {
  final TeacherEntity teacher;
  final bool isKepsek;
  const CardOrganization({
    super.key,
    required this.teacher,
    this.isKepsek = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String jabatan = teacher.tasksName!.firstWhere(
        (item) => item.contains('Wakil Kepala Sekolah'),
        orElse: () => '');
    return CustomInkWell(
      onTap: () => AppNavigator.push(
          context,
          TeacherDetail(
            teacherId: teacher.id ?? 0,
          )),
      borderRadius: 16,
      defaultColor: AppColors.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: NetworkPhoto(
              forceRefresh: false,
              width: width * 0.31,
              height: height * 0.15,
              fallbackAsset: teacher.gender == 1
                  ? AppImages.guruLaki
                  : AppImages.guruPerempuan,
              imageUrl: DisplayImage.displayImageTeacher(
                teacher.name ?? '',
                teacher.nip != null
                    ? teacher.nip!
                    : DateFormat('d MMMM yyyy', "id_ID")
                        .format(teacher.birthDate!),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  teacher.name ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.inversePrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isKepsek ? teacher.nip ?? '' : jabatan,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
