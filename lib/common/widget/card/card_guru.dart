import 'package:flutter/material.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardGuru extends StatefulWidget {
  final TeacherEntity teacher;
  final bool forceRefresh;
  const CardGuru({
    super.key,
    required this.teacher,
    this.forceRefresh = false,
  });

  @override
  State<CardGuru> createState() => _CardGuruState();
}

class _CardGuruState extends State<CardGuru>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String fallbackAsset = widget.teacher.gender == 1
        ? AppImages.guruLaki
        : AppImages.guruPerempuan;

    return SizedBox(
      width: width * 0.45,
      height: height * 0.25,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NetworkPhoto(
              imageUrl: DisplayImage.displayImageTeacher(
                  widget.teacher.picture ?? ''),
              fallbackAsset: fallbackAsset,
              width: width * 0.285,
              height: height * 0.135,
              forceRefresh: false,
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.385,
              height: height * 0.06,
              child: Center(
                child: Text(
                  widget.teacher.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
