import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/cache_state_image.dart';
import '../../helper/display_image.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';

class CardGuruComplete extends StatefulWidget {
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
  State<CardGuruComplete> createState() => _CardGuruCompleteState();
}

class _CardGuruCompleteState extends State<CardGuruComplete> {
  late String imageUrl;
  bool? isReachable;

  @override
  void initState() {
    super.initState();
    imageUrl = DisplayImage.displayImageTeacher(
        widget.teacher.nama,
        widget.teacher.nip != "-"
            ? widget.teacher.nip
            : widget.teacher.tanggalLahir);
    _checkUrl();
  }

  Future<void> _checkUrl() async {
    final reachable = await CacheStateImage.checkUrl(imageUrl);
    if (mounted) {
      setState(() {
        isReachable = reachable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String fallbackAsset = widget.teacher.gender == 1
        ? AppImages.guruLaki
        : AppImages.guruPerempuan;
    Widget imageWidget;

    if (isReachable == null) {
      imageWidget = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width * 0.285,
          height: height * 0.135,
          color: Colors.grey,
        ),
      );
    } else if (isReachable == true) {
      imageWidget = NetworkPhoto(
        imageUrl: imageUrl,
        fallbackAsset: fallbackAsset,
        width: width * 0.285,
        height: height * 0.135,
        forceRefresh: false,
      );
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        width: width * 0.285,
        height: height * 0.135,
        fit: BoxFit.cover,
      );
    }
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: widget.onTap,
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
                    child: imageWidget),
                SizedBox(width: width * 0.05),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.teacher.nama,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          widget.desc,
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
