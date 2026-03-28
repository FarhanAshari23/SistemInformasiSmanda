import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/card/card_basic.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/attandance/attandance_teacher.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/attendance/add_teacher_attendance.dart';
import '../../../domain/usecases/attendance/add_teacher_completion_usecase.dart';
import '../bloc/get_teacher_attendance_cubit.dart';
import '../bloc/get_teacher_attendance_state.dart';
import 'attendance_menu_view.dart';
import 'scan_barcode_view.dart';
import '../bloc/get_distace_state.dart';
import '../bloc/get_distance_cubit.dart';

class ProfileTeacherMenuView extends StatelessWidget {
  final TeacherEntity teacher;
  const ProfileTeacherMenuView({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetDistanceCubit(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) => GetTeacherAttendanceCubit()
            ..getAttendanceTeacherCurrent(teacher.id ?? 0),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetDistanceCubit, GetDistanceState>(
            listener: (context, state) {
              if (state is GetDistanceLoading) {
                var snackbar = const SnackBar(
                  content: Text("Sedang mengecek lokasi..."),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          ),
          BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState || state is ButtonFailureState) {
                Navigator.of(context, rootNavigator: true).pop();

                context
                    .read<GetTeacherAttendanceCubit>()
                    .getAttendanceTeacherCurrent(teacher.id ?? 0);

                String message = state is ButtonSuccessState
                    ? "Proses absen berhasil dilakukan"
                    : (state as ButtonFailureState).errorMessage;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<GetTeacherAttendanceCubit,
                      GetTeacherAttendanceState>(
                    builder: (context, state) {
                      if (state is GetTeacherAttendanceLoading) {
                        return CardBasic(
                          title: "Tunggu Sebentar...",
                          image: AppImages.attendance,
                          onpressed: () {},
                        );
                      }
                      if (state is GetTeacherAttendanceCurrentLoaded) {
                        String formattedTime = DateFormat('HH:mm')
                            .format(state.attendance.checkIn!);
                        return CardBasic(
                          image: AppImages.attendance,
                          color: const Color(0XFFA9A9A9),
                          textColor: Colors.white,
                          onpressed: () async {},
                          title: "Anda sudah absen\n$formattedTime",
                        );
                      }
                      if (state is GetTeacherAttendanceFailure) {
                        if (state.errorMessage ==
                            "Something error: (null):(404):data kehadiran tidak ditemukan") {
                          return Builder(builder: (context) {
                            return CardBasic(
                              image: AppImages.attendance,
                              onpressed: () async {
                                final buttonCubit =
                                    context.read<ButtonStateCubit>();
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      alignment: Alignment.center,
                                      insetPadding: const EdgeInsets.all(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Jenis absen apa yang ingin anda lakukan?",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            BasicButton(
                                              onPressed: () async {
                                                final distanceCubit = context
                                                    .read<GetDistanceCubit>();
                                                final messenger =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                final navigator = Navigator.of(
                                                    context,
                                                    rootNavigator: true);
                                                await distanceCubit
                                                    .getDistance();
                                                if (!context.mounted) return;

                                                final state =
                                                    distanceCubit.state;
                                                if (state
                                                        is GetDistanceLoaded &&
                                                    state.isNear) {
                                                  buttonCubit.execute(
                                                    usecase:
                                                        AddTeacherAttendanceUseCase(),
                                                    params:
                                                        AttandanceTeacherEntity(
                                                      teacherId: teacher.id,
                                                      status: "Hadir",
                                                    ),
                                                  );
                                                } else {
                                                  navigator.pop();
                                                  messenger.showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah"),
                                                    ),
                                                  );
                                                }
                                              },
                                              title: "Hadir",
                                            ),
                                            BasicButton(
                                              onPressed: () {
                                                buttonCubit.execute(
                                                  usecase:
                                                      AddTeacherAttendanceUseCase(),
                                                  params:
                                                      AttandanceTeacherEntity(
                                                    teacherId: teacher.id,
                                                    status: "Izin",
                                                  ),
                                                );
                                              },
                                              title: "Izin",
                                            ),
                                            BasicButton(
                                              onPressed: () {
                                                buttonCubit.execute(
                                                  usecase:
                                                      AddTeacherAttendanceUseCase(),
                                                  params:
                                                      AttandanceTeacherEntity(
                                                    teacherId: teacher.id,
                                                    status: "Sakit",
                                                  ),
                                                );
                                              },
                                              title: "Sakit",
                                            ),
                                            BasicButton(
                                              onPressed: () {
                                                buttonCubit.execute(
                                                  usecase:
                                                      AddTeacherAttendanceUseCase(),
                                                  params:
                                                      AttandanceTeacherEntity(
                                                    teacherId: teacher.id,
                                                    status: "Dinas",
                                                  ),
                                                );
                                              },
                                              title: "Dinas",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              title: 'Absen Masuk',
                            );
                          });
                        } else {
                          return CardBasic(
                            title: state.errorMessage,
                            image: AppImages.attendance,
                            onpressed: () {},
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                  BlocBuilder<GetTeacherAttendanceCubit,
                      GetTeacherAttendanceState>(
                    builder: (context, state) {
                      if (state is GetTeacherAttendanceLoading) {
                        return CardBasic(
                          title: "Tunggu Sebentar...",
                          image: AppImages.attendance,
                          onpressed: () {},
                        );
                      }
                      if (state is GetTeacherAttendanceCurrentLoaded) {
                        String formattedTime = DateFormat('HH:mm')
                            .format(state.attendance.checkOut!);
                        if (formattedTime == "00:00") {
                          return Builder(builder: (context) {
                            return CardBasic(
                              image: AppImages.attendance,
                              onpressed: () async {
                                final distanceCubit =
                                    context.read<GetDistanceCubit>();
                                final buttonCubit =
                                    context.read<ButtonStateCubit>();
                                final messenger = ScaffoldMessenger.of(context);

                                await distanceCubit.getDistance();
                                final state = distanceCubit.state;

                                if (state is GetDistanceLoaded &&
                                    state.isNear) {
                                  buttonCubit.execute(
                                    usecase: AddTeacherCompletionUsecase(),
                                    params: teacher.id,
                                  );
                                } else {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah"),
                                    ),
                                  );
                                }
                              },
                              title: 'Absen Pulang',
                            );
                          });
                        } else {
                          return CardBasic(
                            image: AppImages.attendance,
                            color: const Color(0XFFA9A9A9),
                            textColor: Colors.white,
                            onpressed: () async {},
                            title: "Anda sudah absen\n$formattedTime",
                          );
                        }
                      }
                      if (state is GetTeacherAttendanceFailure) {
                        if (state.errorMessage ==
                            "Something error: (null):(404):data kehadiran tidak ditemukan") {
                          return Builder(builder: (context) {
                            return CardBasic(
                              image: AppImages.attendance,
                              onpressed: () async {
                                final distanceCubit =
                                    context.read<GetDistanceCubit>();
                                final buttonCubit =
                                    context.read<ButtonStateCubit>();
                                final messenger = ScaffoldMessenger.of(context);

                                await distanceCubit.getDistance();
                                final state = distanceCubit.state;

                                if (state is GetDistanceLoaded &&
                                    state.isNear) {
                                  buttonCubit.execute(
                                    usecase: AddTeacherCompletionUsecase(),
                                    params: teacher.id,
                                  );
                                } else {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah"),
                                    ),
                                  );
                                }
                              },
                              title: 'Absen Pulang',
                            );
                          });
                        } else {
                          return CardBasic(
                            title: state.errorMessage,
                            image: AppImages.attendance,
                            onpressed: () {},
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardBasic(
                    image: AppImages.verification,
                    onpressed: () {
                      AppNavigator.push(
                        context,
                        AttendanceMenuView(teacher: teacher),
                      );
                    },
                    title: 'Lihat Data Absen',
                  ),
                  CardBasic(
                    image: AppImages.camera,
                    title: 'Rekam Kehadiran Siswa',
                    onpressed: () {
                      AppNavigator.push(
                        context,
                        const ScanBarcodeView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
