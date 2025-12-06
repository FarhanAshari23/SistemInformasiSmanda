import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../bloc/get_teacher_attendance_cubit.dart';
import '../bloc/get_teacher_attendance_state.dart';
import '../bloc/select_timestamp_cubit.dart';

class ScheduleAttendanceTeacherView extends StatelessWidget {
  final TeacherEntity teacher;
  final bool isAttendance;
  const ScheduleAttendanceTeacherView({
    super.key,
    required this.teacher,
    this.isAttendance = true,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetTeacherAttendanceCubit()..getAttendanceTeacher(teacher),
          ),
          BlocProvider(
            create: (context) => SelectTimestampCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
                isLogout: false,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 12),
                child: Text(
                  isAttendance
                      ? 'Daftar absensi kehadiran'
                      : 'Daftar absensi pulang',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              BlocBuilder<GetTeacherAttendanceCubit, GetTeacherAttendanceState>(
                builder: (context, state) {
                  if (state is GetTeacherAttendanceLoading) {
                    return const Column(
                      children: [
                        SizedBox(height: 80),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  if (state is GetTeacherAttendanceLoaded) {
                    DateFormat format = DateFormat('dd-M-yyyy');
                    List<DateTime> highlightedDates = state.attendances
                        .map((a) => format.parse(a.createdAt))
                        .toList();
                    final lastTimestamp = state.attendances.last.timestamp;
                    final selector = context.read<SelectTimestampCubit>();
                    if (selector.state == null) {
                      selector.select(lastTimestamp);
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CalendarCarousel<Event>(
                          onCalendarChanged: (p0) {},
                          onDayPressed: (date, events) {
                            final dateOnly =
                                DateTime(date.year, date.month, date.day);

                            for (var att in state.attendances) {
                              final attDate = format.parse(att.createdAt);
                              final attOnly = DateTime(
                                  attDate.year, attDate.month, attDate.day);

                              if (attOnly == dateOnly) {
                                context
                                    .read<SelectTimestampCubit>()
                                    .select(att.timestamp);
                                break;
                              }
                            }
                          },
                          headerTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            fontSize: 20,
                          ),
                          iconColor: AppColors.primary,
                          weekendTextStyle: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                          weekdayTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          isScrollable: false,
                          todayButtonColor: AppColors.secondary,
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
                                  color: Colors.green,
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
                            return null; // default style
                          },
                        ),
                      ),
                    );
                  }
                  if (state is GetTeacherAttendanceFailure) {
                    return Text(state.errorMessage);
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<SelectTimestampCubit, Timestamp?>(
                builder: (context, selectedTimestamp) {
                  if (selectedTimestamp == null) {
                    return const SizedBox();
                  }
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: height * 0.125,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isAttendance ? "Jam Masuk:" : "Jam Pulang:",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.inversePrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                DateFormat('HH:mm').format(
                                  selectedTimestamp.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.inversePrimary,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.inversePrimary,
                            size: width * 0.1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
