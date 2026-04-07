import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/detail/teacher_detail.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/attandance/attandance_teacher.dart';

class CardTeacherAttendance extends StatelessWidget {
  final AttandanceTeacherEntity teacher;
  final bool isAttendance;
  const CardTeacherAttendance({
    super.key,
    required this.isAttendance,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;

    DateTime dateTime = DateTime.now();
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
      isAttendance ? 7 : 16,
      isAttendance ? 15 : 00,
    );

    String fallbackAsset =
        teacher.gender == 1 ? AppImages.guruLaki : AppImages.guruPerempuan;

    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: () {
        AppNavigator.push(
          context,
          TeacherDetail(
            teacherId: teacher.teacherId ?? 0,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkPhoto(
                  imageUrl: DisplayImage.displayImageTeacher(
                      teacher.name!,
                      teacher.nip != null
                          ? teacher.nip!
                          : DateFormat('d MMMM yyyy')
                              .format(teacher.birthDate!)),
                  fallbackAsset: fallbackAsset,
                  height: mediaQueryHeight * 0.14,
                  width: width * 0.235,
                  forceRefresh: false,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 16.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '${teacher.name}\n',
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
                            text: teacher.nip,
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
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(12)),
                color:
                    currentTime.isAfter(targetTime) ? Colors.red : Colors.green,
              ),
              child: Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.inversePrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
