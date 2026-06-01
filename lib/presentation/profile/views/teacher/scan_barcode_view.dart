import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../../common/widget/searchbar/search_students_view.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/attandance/attendance_student.dart';
import '../../../../domain/entities/student/student.dart';
import '../../../../domain/usecases/attendance/add_student_attendance.dart';
import '../../../../domain/usecases/students/search_student_by_nisn.dart';
import '../../../admin/attendance/widgets/scan_qr.dart';
import '../../bloc/get_distace_state.dart';
import '../../bloc/get_distance_cubit.dart';
import '../../bloc/student_nisn_cubit.dart';
import '../../bloc/student_nisn_state.dart';

class ScanBarcodeView extends StatelessWidget {
  const ScanBarcodeView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                StudentsNISNCubit(usecase: SearchStudentByNisn()),
          ),
          BlocProvider(
            create: (context) => GetDistanceCubit(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: width * 0.7,
                            height: height * 0.4,
                            child: const ScanQRAttandance(),
                          ),
                          SizedBox(height: height * 0.02),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.inversePrimary,
                            ),
                            child:
                                BlocBuilder<GetDistanceCubit, GetDistanceState>(
                              builder: (context, state) {
                                if (state is GetDistanceLoading) {
                                  return const Text(
                                    'Arahkan Kamera ke Barcode Siswa',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                                if (state is GetDistanceLoaded) {
                                  if (state.isNear) {
                                    return BlocBuilder<StudentsNISNCubit,
                                        StudentsNISNState>(
                                      builder: (context, state) {
                                        if (state is StudentsNISNLoading) {
                                          return const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Tunggu Sebentar...',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              CircularProgressIndicator(),
                                            ],
                                          );
                                        }
                                        if (state is StudentsNISNLoaded) {
                                          return BlocBuilder<ButtonStateCubit,
                                              ButtonState>(
                                            builder: (context, btnState) {
                                              if (btnState
                                                  is ButtonFailureState) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      btnState.errorMessage,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${state.student.name} - ${state.student.nisn}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              if (btnState
                                                  is ButtonSuccessState) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Absen berhasil dilakukan!',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    Text(
                                                      'Nama: ${state.student.name}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    Text(
                                                      'NISN: ${state.student.nisn}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Kelas: ${state.student.nameClass}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              return const SizedBox();
                                            },
                                          );
                                        }
                                        if (state is StudentsNISNFailure) {
                                          return const Center(
                                            child: Text(
                                              'Data Tidak Ditemukan',
                                              style: TextStyle(
                                                fontSize: 32,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }
                                        return const Center(
                                          child: Text(
                                            'Arahkan Kamera ke Barcode Siswa',
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Text(
                                      "Anda tidak berada di lingkungan SMA N 2 Metro, harap melakukan absen di sekolah",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  }
                                }
                                if (state is GetDistanceFailure) {
                                  return Text(
                                    "Error: ${state.errorMessage}",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Builder(builder: (newContext) {
                            return CustomInkWell(
                              borderRadius: 12,
                              defaultColor: AppColors.secondary,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SearchStudentsView(),
                                  ),
                                );

                                if (!newContext.mounted) return;

                                if (result != null) {
                                  StudentEntity student = result;
                                  newContext.read<ButtonStateCubit>().execute(
                                        usecase: AddStudentAttendanceUseCase(),
                                        params: AttendanceStudentEntity(
                                          studentId: student.id,
                                          status: "Izin",
                                        ),
                                      );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Izin Murid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.inversePrimary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
