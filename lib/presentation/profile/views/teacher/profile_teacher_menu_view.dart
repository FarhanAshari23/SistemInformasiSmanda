import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/helper/app_navigation.dart';
import '../../../../common/widget/button/basic_button.dart';
import '../../../../common/widget/card/card_basic.dart';
import '../../../../common/widget/dialog/basic_dialog.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/attandance/attandance_teacher.dart';
import '../../../../domain/entities/teacher/teacher.dart';
import '../../../../domain/usecases/attendance/add_teacher_attendance.dart';
import '../../../../domain/usecases/attendance/add_teacher_completion_usecase.dart';
import '../../../../domain/usecases/auth/logout.dart';
import '../../../admin/attendance/views/see_all_data_attandance_students.dart';
import '../../../admin/schedule/views/edit_schedule_view.dart';
import '../../../auth/views/login_view.dart';
import '../../bloc/get_teacher_attendance_cubit.dart';
import '../../bloc/get_teacher_attendance_state.dart';
import '../../bloc/logout_state.cubit.dart';
import 'create_announcement_view.dart';
import 'list_announcement_view.dart';
import 'scan_barcode_view.dart';
import '../../bloc/get_distace_state.dart';
import '../../bloc/get_distance_cubit.dart';
import 'schedule_attendance_teacher_view.dart';

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
          create: (context) => LogoutStateCubit(),
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
                if (context.read<LogoutStateCubit>().state == 0) {
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
                } else {
                  AppNavigator.pushReplacement(context, LoginView());
                }
              }
            },
          ),
        ],
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
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
                      String formattedTime =
                          DateFormat('HH:mm').format(state.attendance.checkIn!);
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
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: (_) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Jenis absen apa yang ingin anda lakukan?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: BasicButton(
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
                                          ),
                                          Expanded(
                                            child: BasicButton(
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
                                          ),
                                          Expanded(
                                            child: BasicButton(
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
                                          ),
                                          Expanded(
                                            child: BasicButton(
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
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.01),
                                    ],
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

                              if (state is GetDistanceLoaded && state.isNear) {
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

                              if (state is GetDistanceLoaded && state.isNear) {
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
                  image: AppImages.studentAttendance,
                  onpressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "Silakan pilih",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: BasicButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AppNavigator.push(
                                        context,
                                        const SeeAllDataAttandanceStudents(
                                            isProfileTeacher: true),
                                      );
                                    },
                                    title: "Lihat absen murid",
                                  ),
                                ),
                                Expanded(
                                  child: BasicButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AppNavigator.push(
                                        context,
                                        ScheduleAttendanceTeacherView(
                                          teacher: teacher,
                                        ),
                                      );
                                    },
                                    title: "Lihat absen saya",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        );
                      },
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
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardBasic(
                  image: AppImages.megaphone,
                  onpressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "Silakan pilih",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: BasicButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AppNavigator.push(
                                        context,
                                        CreateAnnouncementView(
                                            teacherId: teacher.id ?? 0),
                                      );
                                    },
                                    title: "Buat pengumuman",
                                  ),
                                ),
                                Expanded(
                                  child: BasicButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AppNavigator.push(
                                        context,
                                        ListAnnouncementView(
                                          teacherId: teacher.id ?? 0,
                                        ),
                                      );
                                    },
                                    title: "Pengumuman saya",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        );
                      },
                    );
                  },
                  title: 'Pengumuman',
                ),
                CardBasic(
                  image: AppImages.teaching,
                  title: 'Ubah jadwal',
                  onpressed: () => AppNavigator.push(
                    context,
                    EditScheduleView(
                      teacherId: teacher.id ?? 0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Align(
              alignment: Alignment.bottomRight,
              child: Builder(builder: (outerContext) {
                return CustomInkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BasicDialog(
                          buttonTitle: 'Keluar',
                          mainTitle:
                              'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                          splashImage: AppImages.splashLogout,
                          onPressed: () {
                            outerContext
                                .read<LogoutStateCubit>()
                                .changeState(1);
                            outerContext.read<ButtonStateCubit>().execute(
                                  usecase: LogoutUsecase(),
                                );
                          },
                        );
                      },
                    );
                  },
                  borderRadius: 8,
                  defaultColor: AppColors.primary,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: AppColors.inversePrimary,
                          size: 32,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
