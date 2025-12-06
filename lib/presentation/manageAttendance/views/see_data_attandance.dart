import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/check_same_date.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/attandance/param_delete_attendance.dart';
import '../../../domain/usecases/attendance/delete_attendances_usecase.dart';
import '../../../domain/usecases/attendance/delete_month_attendances_usecase.dart';
import '../../auth/widgets/button_role.dart';
import '../bloc/display_date_cubit.dart';
import '../bloc/display_date_state.dart';
import 'select_class.dart';

class SeeDataAttandance extends StatefulWidget {
  const SeeDataAttandance({super.key});

  @override
  State<SeeDataAttandance> createState() => _SeeDataAttandanceState();
}

class _SeeDataAttandanceState extends State<SeeDataAttandance> {
  DateTime displayedMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DisplayDateCubit()..displayAttendances(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              context.read<DisplayDateCubit>().displayAttendances();
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
                Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        return BasicButton(
                          onPressed: () {
                            final outerContext = context;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                  value: outerContext.read<ButtonStateCubit>(),
                                  child: Dialog(
                                    backgroundColor: AppColors.inversePrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    insetPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.2,
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.6,
                                          height: height * 0.3,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  AppImages.splashDelete),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Apakah anda yakin ingin menghapus kehadiran pada bulan ${displayedMonth.month} tahun ${displayedMonth.year}?',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ButtonRole(
                                                  onPressed: () {
                                                    outerContext
                                                        .read<
                                                            ButtonStateCubit>()
                                                        .execute(
                                                          usecase:
                                                              DeleteMonthAttendancesUsecase(),
                                                          params:
                                                              ParamDeleteAttendance(
                                                            month:
                                                                displayedMonth
                                                                    .month,
                                                            year: displayedMonth
                                                                .year,
                                                          ),
                                                        );
                                                  },
                                                  title: 'Hapus',
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CustomInkWell(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      borderRadius: 12,
                                                      defaultColor:
                                                          AppColors.primary,
                                                      child: SizedBox(
                                                        height: height * 0.085,
                                                        child: const Center(
                                                          child: Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .inversePrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: 'Hapus Bulan Ini',
                        );
                      }),
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        return BasicButton(
                          onPressed: () {
                            final outerContext = context;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                  value: outerContext.read<ButtonStateCubit>(),
                                  child: Dialog(
                                    backgroundColor: AppColors.inversePrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    insetPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.2,
                                      horizontal: 16,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.6,
                                          height: height * 0.3,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  AppImages.splashDelete),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Apakah anda yakin ingin menghapus seluruh kehadiran ?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ButtonRole(
                                                  onPressed: () {
                                                    outerContext
                                                        .read<
                                                            ButtonStateCubit>()
                                                        .execute(
                                                          usecase:
                                                              DeleteAttendancesUsecase(),
                                                        );
                                                  },
                                                  title: 'Hapus',
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CustomInkWell(
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                      borderRadius: 12,
                                                      defaultColor:
                                                          AppColors.primary,
                                                      child: SizedBox(
                                                        height: height * 0.085,
                                                        child: const Center(
                                                          child: Text(
                                                            'Batal',
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .inversePrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: 'Hapus Semua',
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
