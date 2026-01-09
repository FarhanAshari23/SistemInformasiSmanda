import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../helper/cache_state_image.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardStaff extends StatefulWidget {
  final TeacherEntity teacher;
  final String? content;
  final bool forceRefresh;
  final Widget page;
  const CardStaff({
    super.key,
    this.content,
    required this.teacher,
    required this.page,
    this.forceRefresh = true,
  });

  @override
  State<CardStaff> createState() => _CardStaffState();
}

class _CardStaffState extends State<CardStaff> {
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
        ? AppImages.tendikLaki
        : AppImages.tendikPerempuan;
    Widget imageWidget;

    if (isReachable == null) {
      imageWidget = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width * 0.24,
          height: height * 0.115,
          color: Colors.grey,
        ),
      );
    } else if (isReachable == true) {
      imageWidget = NetworkPhoto(
        width: width * 0.24,
        height: height * 0.115,
        fallbackAsset: fallbackAsset,
        imageUrl: imageUrl,
      );
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        width: width * 0.24,
        height: height * 0.115,
        fit: BoxFit.cover,
      );
    }
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, widget.page),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
            SizedBox(height: height * 0.01),
            Column(
              children: [
                Center(
                  child: Text(
                    widget.teacher.nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  widget.content != null
                      ? widget.content!
                      : widget.teacher.jabatan,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
