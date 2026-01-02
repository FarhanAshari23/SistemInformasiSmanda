import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/cache_state_image.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardGuru extends StatefulWidget {
  final TeacherEntity teacher;
  final bool forceRefresh;
  const CardGuru({
    super.key,
    required this.teacher,
    this.forceRefresh = true,
  });

  @override
  State<CardGuru> createState() => _CardGuruState();
}

class _CardGuruState extends State<CardGuru> {
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

    return SizedBox(
      width: width * 0.45,
      height: height * 0.25,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageWidget,
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.385,
              height: height * 0.06,
              child: Center(
                child: Text(
                  widget.teacher.nama,
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
