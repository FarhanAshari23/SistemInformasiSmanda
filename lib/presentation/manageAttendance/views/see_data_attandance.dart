import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/check_same_date.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/select_class.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/display_date_cubit.dart';
import '../bloc/display_date_state.dart';

class SeeDataAttandance extends StatelessWidget {
  const SeeDataAttandance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DisplayDateCubit()..displayAttendances(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
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
                  if (state is DisplayDateLoaded) {
                    DateFormat format = DateFormat('dd-M-yyyy');
                    List<DateTime> highlightedDates = state.attendances
                        .map((a) => format.parse(a.createdAt))
                        .toList();
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CalendarCarousel<Event>(
                          onDayPressed: (date, events) {
                            bool isHighlighted = highlightedDates.any(
                              (element) => isSameDate(element, date),
                            );
                            if (isHighlighted) {
                              String formatted =
                                  DateFormat('dd-M-yyyy').format(date);
                              AppNavigator.push(
                                context,
                                BlocProvider.value(
                                  value: GetAllKelasCubit(),
                                  child: SelectClass(date: formatted),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Tanggal ini belum dibuat list absensinya, silakan buat terlebih dahulu."),
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
                                  color: Colors
                                      .green, // sama seperti selectedDayButtonColor
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(
                                      color: Colors
                                          .white, // teks putih biar kontras
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
