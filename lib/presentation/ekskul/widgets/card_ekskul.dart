import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/photo/network_photo.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../../../common/helper/display_image.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardEkskul extends StatelessWidget {
  final EkskulEntity ekskul;
  const CardEkskul({
    super.key,
    required this.ekskul,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: ekskul.picture != "",
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                  ),
                ),
                child: NetworkPhoto(
                  height: 30,
                  width: 30,
                  imageUrl:
                      DisplayImage.displayImageEkskul(ekskul.picture ?? ''),
                  fallbackAsset: AppImages.eskul,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ekskul.nameEkskul ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.inversePrimary,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: List.generate(
                ekskul.advisors!.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment:
                          ekskul.advisors![index].name!.length > 25
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.manage_accounts,
                          color: AppColors.inversePrimary,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          ': ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inversePrimary,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Expanded(
                          child: Text(
                            ekskul.advisors![index].name ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inversePrimary,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: ekskul.advisors![0].name!.length > 25
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.groups_2,
                  color: AppColors.inversePrimary,
                ),
                const SizedBox(width: 3),
                const Text(
                  ': ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.start,
                ),
                Expanded(
                  child: Text(
                    '${ekskul.members!.where((e) => e.role == "Anggota").toList().length} anggota',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
