import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/photo/network_photo.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/helper/cache_state_image.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/user.dart';

class CardStudentAttendance extends StatefulWidget {
  final UserEntity student;
  const CardStudentAttendance({
    super.key,
    required this.student,
  });

  @override
  State<CardStudentAttendance> createState() => _CardStudentAttendanceState();
}

class _CardStudentAttendanceState extends State<CardStudentAttendance> {
  late String imageUrl;
  bool? isReachable;

  @override
  void initState() {
    super.initState();
    imageUrl = DisplayImage.displayImageStudent(
        widget.student.nama ?? '', widget.student.nisn ?? '');
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

    DateTime dateTime = widget.student.timeIn!.toDate();
    String time = DateFormat('HH:mm').format(dateTime);
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final currentTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
    );
    final targetTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      7,
      15,
    );

    String fallbackAsset = widget.student.gender == 1
        ? AppImages.boyStudent
        : widget.student.agama == "Islam"
            ? AppImages.girlStudent
            : AppImages.girlNonStudent;
    Widget imageWidget;

    if (isReachable == null) {
      imageWidget = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: mediaQueryHeight * 0.14,
          width: width * 0.235,
          color: Colors.grey,
        ),
      );
    } else if (isReachable == true) {
      imageWidget = NetworkPhoto(
        height: mediaQueryHeight * 0.14,
        width: width * 0.235,
        fallbackAsset: fallbackAsset,
        imageUrl: imageUrl,
      );
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        height: mediaQueryHeight * 0.14,
        width: width * 0.235,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: width * 0.7,
      height: bodyHeight * 0.175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
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
                        width: width * 0.385,
                        height: bodyHeight * 0.09,
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: '${widget.student.nama}\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                            children: [
                              WidgetSpan(
                                child: SizedBox(
                                  height: bodyHeight * 0.03,
                                ),
                              ),
                              TextSpan(
                                text: widget.student.nisn!,
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: width * 0.185,
              height: bodyHeight * 0.06,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(12)),
                color:
                    currentTime.isAfter(targetTime) ? Colors.red : Colors.green,
              ),
              child: Center(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
