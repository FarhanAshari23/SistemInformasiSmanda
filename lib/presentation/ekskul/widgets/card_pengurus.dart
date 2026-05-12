import 'package:flutter/material.dart';

import '../../../common/helper/display_image.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/member.dart';

class CardPengurus extends StatelessWidget {
  final MemberEntity member;
  const CardPengurus({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondary,
        ),
        child: Row(
          children: [
            NetworkPhoto(
              fallbackAsset: member.gender == 1
                  ? AppImages.boyStudent
                  : member.religion == "Islam"
                      ? AppImages.girlStudent
                      : AppImages.girlNonStudent,
              imageUrl: DisplayImage.displayImageStudent(member.picture ?? ''),
              height: width * 0.1,
              width: width * 0.1,
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    member.role ?? '',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    member.name ?? '',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
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
