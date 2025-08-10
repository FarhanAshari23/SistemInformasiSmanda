import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/attendance/add_student_attendance.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/search_student_by_nisn.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/student_nisn_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/student_nisn_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/screens/succes_add_attandance.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/scan_qr.dart';

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
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
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
              children: [
                const BasicAppbar(isBackViewed: true, isProfileViewed: false),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width * 0.7,
                        height: height * 0.4,
                        child: const ScanQRAttandance(),
                      ),
                      SizedBox(height: height * 0.02),
                      Container(
                        width: double.infinity,
                        height: height * 0.35,
                        color: AppColors.inversePrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child:
                              BlocBuilder<StudentsNISNCubit, StudentsNISNState>(
                            builder: (context, state) {
                              if (state is StudentsNISNLoading) {
                                return const Row(
                                  children: [
                                    Text('Tunggu Sebentar...'),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              }
                              if (state is StudentsNISNLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Data Siswa Berhasil Didapatkan!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Text(
                                      'Nama: ${state.student.nama}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'NISN: ${state.student.nisn}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      'Kelas: ${state.student.kelas}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Center(
                                      child: Builder(builder: (context) {
                                        return BasicButton(
                                          onPressed: () {
                                            context
                                                .read<ButtonStateCubit>()
                                                .execute(
                                                    usecase:
                                                        AddStudentAttendanceUseCase(),
                                                    params: state.student);
                                            AppNavigator.push(
                                              context,
                                              SuccesAddAttandance(
                                                userEntity: state.student,
                                              ),
                                            );
                                          },
                                          title: 'Tambah',
                                        );
                                      }),
                                    )
                                  ],
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
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
