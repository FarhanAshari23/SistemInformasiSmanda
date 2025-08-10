import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/helper/display_image.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/user.dart';

class CardUserAttendance extends StatelessWidget {
  final UserEntity student;
  const CardUserAttendance({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    DateTime dateTime = student.timeIn!.toDate();
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
                SizedBox(
                  width: width * 0.235,
                  height: bodyHeight * 0.14,
                  child: CachedNetworkImage(
                    imageUrl: DisplayImage.displayImageStudent(
                      student.nama!,
                      student.nisn!,
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      student.gender == 1
                          ? AppImages.boyStudent
                          : AppImages.girlStudent,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
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
                            text: '${student.nama}\n',
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
                                text: student.nisn!,
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
