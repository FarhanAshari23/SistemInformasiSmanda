import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/check_same_date.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/display_date_cubit.dart';
import '../bloc/display_date_state.dart';
import 'select_class.dart';

class SeeAllDataAttandanceStudents extends StatefulWidget {
  final bool isProfileTeacher;
  const SeeAllDataAttandanceStudents({
    super.key,
    this.isProfileTeacher = false,
  });

  @override
  State<SeeAllDataAttandanceStudents> createState() =>
      _SeeAllDataAttandanceStudentsState();
}

class _SeeAllDataAttandanceStudentsState
    extends State<SeeAllDataAttandanceStudents> {
  DateTime displayedMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DisplayDateCubit()..displayStudentAttendances(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              context.read<DisplayDateCubit>().displayStudentAttendances();
              var snackbar = const SnackBar(
                content: Text("Data Berhasil dihapus"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);

              Navigator.pop(context);
            }
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(isBackViewed: true),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 12),
                  child: Text(
                    'Silakan pilih tanggal: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                BlocBuilder<DisplayDateCubit, DisplayDateState>(
                  builder: (context, state) {
                    if (state is DisplayDateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is DisplayDateStudentLoaded) {
                      List<DateTime> highlightedDates =
                          state.attendances.map((a) => a.date!).toList();
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
                                AppNavigator.push(
                                  context,
                                  BlocProvider.value(
                                    value: GetAllKelasCubit(),
                                    child: SelectClass(date: date),
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
      ),
    );
  }
}
