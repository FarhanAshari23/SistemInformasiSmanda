import 'package:flutter/material.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/detail/murid_detail.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/member.dart';

class TileAnggota extends StatelessWidget {
  final MemberEntity anggota;
  const TileAnggota({
    super.key,
    required this.anggota,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return CustomInkWell(
      defaultColor: Colors.transparent,
      borderRadius: 8,
      onTap: () => AppNavigator.push(
        context,
        MuridDetail(userId: anggota.id ?? 0),
      ),
      child: Column(
        children: [
          NetworkPhoto(
            shape: BoxShape.circle,
            fallbackAsset: anggota.gender == 1
                ? AppImages.boyStudent
                : anggota.religion == "Islam"
                    ? AppImages.girlStudent
                    : AppImages.girlNonStudent,
            imageUrl: DisplayImage.displayImageStudent(anggota.picture ?? ''),
            width: height * 0.05,
            height: height * 0.05,
          ),
          SizedBox(height: height * 0.004),
          Text(
            anggota.name ?? '',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
