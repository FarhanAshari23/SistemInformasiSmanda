import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class NotFound extends StatelessWidget {
  final String objek;
  const NotFound({
    super.key,
    required this.objek,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Container(
            width: width * 0.9,
            height: height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.notfound),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Data $objek yang kamu cari tidak ditemukan, harap tulis nama dengan benar",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
