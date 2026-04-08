import 'package:flutter/material.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../detail/teacher_detail.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';

class CardGuruComplete extends StatelessWidget {
  final TeacherEntity teacher;
  final String desc;
  final VoidCallback? onTap;
  final bool forceRefresh;
  const CardGuruComplete({
    super.key,
    required this.teacher,
    this.onTap,
    required this.desc,
    this.forceRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String fallbackAsset =
        teacher.gender == 1 ? AppImages.guruLaki : AppImages.guruPerempuan;

    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: () => AppNavigator.push(
        context,
        TeacherDetail(
          teacherId: teacher.id ?? 0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: NetworkPhoto(
                    imageUrl:
                        DisplayImage.displayImageTeacher(teacher.picture ?? ''),
                    fallbackAsset: fallbackAsset,
                    width: width * 0.285,
                    height: height * 0.15,
                    forceRefresh: false,
                  ),
                ),
                SizedBox(width: width * 0.05),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          teacher.name ?? '',
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          desc,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
              ),
              color: AppColors.primary,
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
