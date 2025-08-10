import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardProfile extends StatelessWidget {
  final UserEntity user;
  const CardProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.835,
      height: height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 18,
          top: 18,
          left: 16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              height: height * 0.15,
              child: CachedNetworkImage(
                imageUrl:
                    DisplayImage.displayImageStudent(user.nama!, user.nisn!),
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
            Padding(
              padding: const EdgeInsets.only(top: 19, left: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        height: height * 0.055,
                        child: Text(
                          user.nama!,
                          style: const TextStyle(
                            color: AppColors.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        user.nisn!,
                        style: const TextStyle(
                          color: AppColors.inversePrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      user.kelas!,
                      style: const TextStyle(
                        color: AppColors.inversePrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
