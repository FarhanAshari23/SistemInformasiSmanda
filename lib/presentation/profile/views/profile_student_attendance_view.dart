import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../bloc/get_attendance_student_cubit.dart';
import '../bloc/get_attendance_student_state.dart';

class ProfileStudentAttendanceView extends StatelessWidget {
  final StudentEntity? student;
  const ProfileStudentAttendanceView({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
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
      7,
      15,
    );
    return BlocBuilder<GetStudentAttendanceCubit, GetAttendanceStudentState>(
      builder: (context, state) {
        if (state is GetAttendanceStudentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetAttendanceStudentLoaded) {
          List<DateTime> highlightedDates =
              state.attendances.map((a) => a.date!).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CalendarCarousel<Event>(
              onCalendarChanged: (p0) {},
              headerTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontSize: 20,
              ),
              iconColor: AppColors.primary,
              weekendTextStyle: const TextStyle(
                color: Color(0xFFCD5C5C),
                fontWeight: FontWeight.w700,
              ),
              weekdayTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              isScrollable: false,
              daysTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              nextDaysTextStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              prevDaysTextStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
              customDayBuilder: (
                bool isSelectable,
                int index,
                bool isSelectedDay,
                bool isToday,
                bool isPrevMonthDay,
                TextStyle textStyle,
                bool isNextMonthDay,
                bool isThisMonthDay,
                DateTime date,
              ) {
                if (highlightedDates.any((d) =>
                    d.day == date.day &&
                    d.month == date.month &&
                    d.year == date.year)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: currentTime.isAfter(targetTime)
                          ? Colors.red
                          : Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          );
        }
        if (state is GetAttendanceStudentFailure) {
          if (state.errorMessage ==
              "Something error: (null):(404):Data absen tidak ditemukan") {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.emptyRegistrationChara,
                  width: 120,
                  height: 120,
                ),
                const Text(
                  'Data absen tidak ditemukan',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Terjadi kesalahan: ${state.errorMessage}"),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
