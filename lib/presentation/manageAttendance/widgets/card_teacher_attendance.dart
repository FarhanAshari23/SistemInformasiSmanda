import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/helper/cache_state_image.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardTeacherAttendance extends StatefulWidget {
  final TeacherEntity teacher;
  final bool isAttendance;
  const CardTeacherAttendance({
    super.key,
    required this.isAttendance,
    required this.teacher,
  });

  @override
  State<CardTeacherAttendance> createState() => _CardTeacherAttendanceState();
}

class _CardTeacherAttendanceState extends State<CardTeacherAttendance> {
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
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;

    DateTime dateTime = widget.isAttendance
        ? widget.teacher.timeIn!.toDate()
        : widget.teacher.timeOut!.toDate();
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
      widget.isAttendance ? 7 : 16,
      widget.isAttendance ? 15 : 00,
    );

    String fallbackAsset = widget.teacher.gender == 1
        ? AppImages.guruLaki
        : AppImages.guruPerempuan;
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
        imageUrl: imageUrl,
        fallbackAsset: fallbackAsset,
        height: mediaQueryHeight * 0.14,
        width: width * 0.235,
        forceRefresh: false,
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
                            text: '${widget.teacher.nama}\n',
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
                                text: widget.teacher.nip,
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
