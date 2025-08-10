import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/attendance/create_attendance.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/check_press_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/check_press_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/screens/succes_add_date.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/scan_barcode_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/see_data_attandance.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/widgets/card_feature.dart';

import '../../../service_locator.dart';

class ManageDataAttendances extends StatelessWidget {
  const ManageDataAttendances({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (context) => CheckPressCubit()..checkLastPress(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              const Text(
                'Apa yang ingin dilakukan?:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardFeature(
                          onpressed: () => AppNavigator.push(
                              context, const ScanBarcodeView()),
                          title: 'Scan QR Siswa',
                          image: AppImages.camera,
                        ),
                        BlocBuilder<CheckPressCubit, CheckPressState>(
                          builder: (context, state) {
                            return CardFeature(
                              onpressed: state is MyWidgetPressed
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: AppColors.primary,
                                            title: const Text(
                                              'Database Absen Hari ini Sudah Tersedia!',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.inversePrimary,
                                              ),
                                            ),
                                            content: const Text(
                                              'Silakan input data siswa yang hadir dengan scan barcode',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.inversePrimary,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .inversePrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  : () async {
                                      context
                                          .read<CheckPressCubit>()
                                          .buttonPressed();
                                      var returnedData =
                                          await sl<CreateAttendanceUseCase>()
                                              .call();
                                      returnedData.fold(
                                        (l) {
                                          return Container();
                                        },
                                        (r) {
                                          AppNavigator.push(
                                              context, const SuccesAddDate());
                                        },
                                      );
                                    },
                              title: 'Buat Data Kehadiran',
                              image: AppImages.attendance,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.025),
                    CardFeature(
                      onpressed: () => AppNavigator.push(
                        context,
                        const SeeDataAttandance(),
                      ),
                      title: 'Lihat Data Kehadiran',
                      image: AppImages.verification,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
