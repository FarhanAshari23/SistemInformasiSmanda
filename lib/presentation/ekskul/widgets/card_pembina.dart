import 'package:flutter/material.dart';

import '../../../common/helper/display_image.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/ekskul.dart';

class CardPembina extends StatelessWidget {
  final EkskulEntity ekskul;
  final int index;
  const CardPembina({
    super.key,
    required this.ekskul,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          NetworkPhoto(
            fallbackAsset: ekskul.advisors![index].gender == 1
                ? AppImages.guruLaki
                : AppImages.guruPerempuan,
            imageUrl: DisplayImage.displayImageTeacher(
                ekskul.advisors![index].picture ?? ''),
            height: width * 0.2,
            width: width * 0.2,
            shape: BoxShape.circle,
          ),
          const SizedBox(height: 4),
          Text(
            ekskul.advisors![index].name ?? '',
            style: const TextStyle(
              color: AppColors.inversePrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
