import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/user.dart';
import '../../helper/cache_state_image.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';

class CardUser extends StatefulWidget {
  final UserEntity user;
  final VoidCallback? onTap;
  final bool forceRefresh;
  const CardUser({
    super.key,
    required this.user,
    required this.onTap,
    this.forceRefresh = true,
  });

  @override
  State<CardUser> createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  late String imageUrl;
  bool? isReachable;

  @override
  void initState() {
    super.initState();
    imageUrl = DisplayImage.displayImageStudent(
        widget.user.nama ?? '', widget.user.nisn ?? '');
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
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    String fallbackAsset = widget.user.gender == 1
        ? AppImages.boyStudent
        : widget.user.agama == "Islam"
            ? AppImages.girlStudent
            : AppImages.girlNonStudent;
    Widget imageWidget;

    if (isReachable == null) {
      imageWidget = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width * 0.235,
          height: bodyHeight * 0.14,
          color: Colors.grey,
        ),
      );
    } else if (isReachable == true) {
      imageWidget = NetworkPhoto(
        width: width * 0.235,
        height: bodyHeight * 0.14,
        fallbackAsset: fallbackAsset,
        imageUrl: imageUrl,
      );
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        width: width * 0.235,
        height: bodyHeight * 0.14,
        fit: BoxFit.cover,
      );
    }
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: widget.onTap,
      child: SizedBox(
        width: width * 0.7,
        height: bodyHeight * 0.175,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  imageWidget,
                  SizedBox(width: width * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.465,
                          height: bodyHeight * 0.06,
                          child: Text(
                            widget.user.nama ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          widget.user.nisn ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: width * 0.1,
                height: bodyHeight * 0.05,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(12)),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
