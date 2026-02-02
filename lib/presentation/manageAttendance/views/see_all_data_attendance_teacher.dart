import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/attendance_teacher_cubit.dart';

import '../../../common/bloc/attendance/select_attendance_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/check_same_date.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/attandance/param_attendance_teacher.dart';
import '../bloc/display_date_cubit.dart';
import '../bloc/display_date_state.dart';
import 'teachers_attendances_views.dart';

class SeeAllDataAttendanceTeacher extends StatefulWidget {
  const SeeAllDataAttendanceTeacher({super.key});

  @override
  State<SeeAllDataAttendanceTeacher> createState() =>
      _SeeAllDataAttendanceTeacherState();
}

class _SeeAllDataAttendanceTeacherState
    extends State<SeeAllDataAttendanceTeacher> {
  DateTime displayedMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DisplayDateCubit()..displayTeacherAttendances(),
          ),
          BlocProvider(
            create: (context) => SelectAttendanceCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
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
                            if (index == 0) {
                              context
                                  .read<SelectAttendanceCubit>()
                                  .stateAttendance(index);
                              context
                                  .read<DisplayDateCubit>()
                                  .displayTeacherAttendances();
                            } else {
                              context
                                  .read<SelectAttendanceCubit>()
                                  .stateAttendance(index);
                              context
                                  .read<DisplayDateCubit>()
                                  .displayTeacherCompletions();
                            }
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
              BlocBuilder<DisplayDateCubit, DisplayDateState>(
                builder: (context, state) {
                  if (state is DisplayDateLoading) {
                    return Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is DisplayDateLoaded) {
                    DateFormat format = DateFormat('dd-M-yyyy');
                    List<DateTime> highlightedDates = state.attendances
                        .map((a) => format.parse(a.createdAt))
                        .toList();
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CalendarCarousel<Event>(
                          onCalendarChanged: (p0) {
                            setState(() {
                              displayedMonth = p0;
                            });
                          },
                          onDayPressed: (date, events) {
                            bool isHighlighted = highlightedDates.any(
                              (element) => isSameDate(element, date),
                            );
                            if (isHighlighted) {
                              final state =
                                  context.read<SelectAttendanceCubit>().state;
                              String formatted =
                                  DateFormat('dd-MM-yyyy').format(date);
                              AppNavigator.push(
                                context,
                                BlocProvider.value(
                                  value: AttendanceTeacherCubit()
                                    ..displayAttendanceTeacher(
                                      ParamAttendanceTeacher(
                                        date: formatted,
                                        isAttendance: state == 0 ? false : true,
                                      ),
                                    ),
                                  child: TeachersAttendancesViews(
                                    isAttendace: state == 0 ? true : false,
                                  ),
                                ),
                              );
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
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
