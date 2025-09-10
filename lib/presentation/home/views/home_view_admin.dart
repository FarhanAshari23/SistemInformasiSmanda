import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/add_account_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/bloc/check_press_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageAttendance/views/manage_data_attendances.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/add_data_ekskul_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/edit_data_ekskul_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/views/add_news_view.dart';
import 'package:new_sistem_informasi_smanda/common/widget/screen/manage_object_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_activity.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/views/edit_news_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/edit_student_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/register_student_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/add_teacher_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/edit_teacher_view.dart';
import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../domain/usecases/attendance/create_attendance.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../service_locator.dart';
import '../../auth/views/login_view.dart';
import '../../manageAttendance/bloc/check_press_state.dart';
import '../../manageAttendance/screens/succes_add_date.dart';
import '../../manageAttendance/views/scan_barcode_view.dart';
import '../../manageAttendance/views/see_data_attandance.dart';
import '../../manageAttendance/widgets/card_feature.dart';
import '../../manageSchedule/views/add_schedule_view.dart';
import '../../manageSchedule/views/edit_schedule_view.dart';

class HomeViewAdmin extends StatelessWidget {
  const HomeViewAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> title = [
      'Scan barcode absen',
      'Buat data kehadiran',
      'Lihat data kehadiran',
      'Registrasi data siswa',
      'Edit data siswa',
      'Tambah data guru',
      'Edit data guru',
      'Buat pengumuman',
      'Edit pengumuman',
      'Tambah data ekskul',
      'Edit data ekskul',
      'Tambah data jadwal',
      'Edit data jadwal',
    ];
    List<String> images = [
      AppImages.camera,
      AppImages.attendance,
      AppImages.verification,
      AppImages.students,
      AppImages.students,
      AppImages.teacher,
      AppImages.teacher,
      AppImages.megaphone,
      AppImages.megaphone,
      AppImages.eskul,
      AppImages.eskul,
      AppImages.calendar,
      AppImages.calendar,
    ];
    List<Widget> pages = [
      const ScanBarcodeView(),
      Container(),
      const SeeDataAttandance(),
      const RegisterStudentView(),
      const EditStudentView(),
      AddTeacherView(),
      const EditTeacherView(),
      AddNewsView(),
      const EditNewsView(),
      const AddDataEkskulView(),
      const EditDataEkskulView(),
      const AddScheduleView(),
      const EditScheduleView(),
    ];
    return Scaffold(
      body: BlocProvider(
        create: (context) => CheckPressCubit()..checkLastPress(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: height * 0.155,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.09,
                      color: AppColors.secondary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: SizedBox(
                                        height: height * 0.565,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                AppImages.splashLogout,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              const Text(
                                                'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      AppColors.inversePrimary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              BlocProvider(
                                                create: (context) =>
                                                    ButtonStateCubit(),
                                                child: BlocListener<
                                                    ButtonStateCubit,
                                                    ButtonState>(
                                                  listener: (context, state) {
                                                    if (state
                                                        is ButtonSuccessState) {
                                                      AppNavigator
                                                          .pushReplacement(
                                                              context,
                                                              LoginView());
                                                    }
                                                    if (state
                                                        is ButtonFailureState) {
                                                      var snackbar = SnackBar(
                                                        content: Text(
                                                            state.errorMessage),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackbar);
                                                    }
                                                  },
                                                  child: Builder(
                                                    builder: (context) {
                                                      return BasicButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  ButtonStateCubit>()
                                                              .execute(
                                                                usecase:
                                                                    LogoutUsecase(),
                                                              );
                                                        },
                                                        title: 'Keluar',
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: width * 0.125,
                                height: height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.tertiary,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.logout,
                                    color: AppColors.inversePrimary,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: width * 0.4,
                      child: Image.asset(
                        AppImages.logoSMA,
                        width: width * 0.2,
                        height: height * 0.095,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.0095),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Selamat Datang Admin',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Apa yang ingin anda lakukan hari ini?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: title.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: height * 0.25,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 1) {
                      return BlocBuilder<CheckPressCubit, CheckPressState>(
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
                                                  color:
                                                      AppColors.inversePrimary,
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
                      );
                    }
                    return CardFeature(
                      onpressed: () => AppNavigator.push(context, pages[index]),
                      title: title[index],
                      image: images[index],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
