import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../bloc/get_teacher_attendance_cubit.dart';
import '../bloc/get_teacher_attendance_state.dart';
import '../bloc/select_attendance_cubit.dart';
import '../bloc/select_date_cubit.dart';
import '../bloc/select_timestamp_cubit.dart';

class ScheduleAttendanceTeacherView extends StatelessWidget {
  final TeacherEntity teacher;

  const ScheduleAttendanceTeacherView({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GetTeacherAttendanceCubit()
              ..getAttendanceTeacher(
                teacher.copyWith(isAttendance: true),
              ),
          ),
          BlocProvider(create: (_) => SelectTimestampCubit()),
          BlocProvider(create: (_) => SelectedDateCubit()),
          BlocProvider(create: (_) => SelectAttendanceCubit()),
        ],
        child: _MainContent(teacher: teacher),
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final TeacherEntity teacher;

  const _MainContent({
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<SelectAttendanceCubit, int>(
      listener: (context, state) {
        final updatedTeacher = teacher.copyWith(
          isAttendance: state == 0 ? true : false,
        );

        context
            .read<GetTeacherAttendanceCubit>()
            .getAttendanceTeacher(updatedTeacher);
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
              isLogout: false,
            ),
            SizedBox(height: height * 0.01),
            Center(
              child: BlocBuilder<SelectAttendanceCubit, int>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      2,
                      (index) => CustomInkWell(
                        defaultColor: state == index
                            ? AppColors.primary
                            : AppColors.inversePrimary,
                        left: index == 0 ? 12 : 0,
                        right: index == 1 ? 12 : 0,
                        onTap: () {
                          context
                              .read<SelectAttendanceCubit>()
                              .stateAttendance(index);
                          context.read<SelectTimestampCubit>().reset();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            index == 0 ? "Absen Masuk" : "Absen Pulang",
                            style: TextStyle(
                              color: state == index
                                  ? AppColors.inversePrimary
                                  : AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.01),
            BlocListener<GetTeacherAttendanceCubit, GetTeacherAttendanceState>(
              listener: (context, state) {
                if (state is GetTeacherAttendanceLoaded &&
                    state.attendances.isNotEmpty) {
                  DateFormat format = DateFormat('dd-M-yyyy');

                  String lastTimestamp =
                      format.format(state.attendances.last.timestamp.toDate());
                  String today = format.format(Timestamp.now().toDate());

                  if (lastTimestamp == today) {
                    context
                        .read<SelectTimestampCubit>()
                        .select(state.attendances.last.timestamp);
                  }
                }
              },
              child: BlocBuilder<GetTeacherAttendanceCubit,
                  GetTeacherAttendanceState>(
                builder: (context, state) {
                  if (state is GetTeacherAttendanceLoading) {
                    return Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is GetTeacherAttendanceFailure) {
                    return Center(child: Text(state.errorMessage));
                  }

                  if (state is GetTeacherAttendanceLoaded) {
                    DateFormat format = DateFormat('dd-M-yyyy');

                    List<DateTime> highlightedDates = state.attendances
                        .map((a) => format.parse(a.createdAt))
                        .toList();

                    final selectedDate =
                        context.watch<SelectedDateCubit>().state;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CalendarCarousel<Event>(
                          onDayPressed: (date, _) {
                            final dateOnly =
                                DateTime(date.year, date.month, date.day);

                            context
                                .read<SelectedDateCubit>()
                                .selectDate(dateOnly);

                            bool found = false;

                            for (var att in state.attendances) {
                              final attDate = format.parse(att.createdAt);
                              final attOnly = DateTime(
                                  attDate.year, attDate.month, attDate.day);

                              if (attOnly == dateOnly) {
                                found = true;
                                context
                                    .read<SelectTimestampCubit>()
                                    .select(att.timestamp);
                                break;
                              }
                            }

                            if (!found) {
                              context.read<SelectTimestampCubit>().reset();
                            }
                          },
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
                            final isSelected = selectedDate != null &&
                                selectedDate.day == date.day &&
                                selectedDate.month == date.month &&
                                selectedDate.year == date.year;

                            final isHighlighted = highlightedDates.any((d) =>
                                d.day == date.day &&
                                d.month == date.month &&
                                d.year == date.year);

                            if (isHighlighted) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    "${date.day}",
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
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            /// TIMESTAMP DISPLAY
            BlocBuilder<SelectTimestampCubit, Timestamp?>(
              builder: (context, selectedTimestamp) {
                if (selectedTimestamp == null) {
                  return const SizedBox();
                }

                final isAttendance =
                    context.watch<SelectAttendanceCubit>().state == 0;

                return Container(
                  padding: const EdgeInsets.all(24),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, bottom: height * 0.1),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
