import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
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
import '../../../domain/usecases/auth/logout.dart';
import '../../auth/views/login_view.dart';

class HomeViewAdmin extends StatelessWidget {
  const HomeViewAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> title = [
      'Olah Data Kehadiran',
      'Olah Data Siswa',
      'Olah Data Guru',
      'Unggah Pengumuman',
      'Olah Data Ekskul',
    ];
    List<String> images = [
      AppImages.verification,
      AppImages.students,
      AppImages.teacher,
      AppImages.megaphone,
      AppImages.eskul,
    ];
    List<Widget> pages = [
      const ManageDataAttendances(),
      const ManageObjectView(
        title: 'Apa yang ingin anda lakukan dengan data murid',
        namaFiturSatu: 'Registrasi Data Murid',
        namaFiturDua: 'Edit Data Murid',
        pageSatu: RegisterStudentView(),
        pageDua: EditStudentView(),
      ),
      ManageObjectView(
        title: 'Apa yang ingin anda lakukan dengan data guru',
        namaFiturSatu: 'Tambah Data Guru',
        namaFiturDua: 'Edit Data Guru',
        pageSatu: AddTeacherView(),
        pageDua: const EditTeacherView(),
      ),
      ManageObjectView(
        title: 'Apa yang ingin anda lakukan dengan data pengumuman',
        namaFiturSatu: 'Tambah Data Pengumuman',
        namaFiturDua: 'Edit Data Pengumuman',
        pageSatu: AddNewsView(),
        pageDua: const EditNewsView(),
      ),
      ManageObjectView(
        title: 'Apa yang ingin anda lakukan dengan data ekskul',
        namaFiturSatu: 'Tambah Data Ekskul',
        namaFiturDua: 'Edit Data Ekskul',
        pageSatu: AddDataEkskulView(),
        pageDua: const EditDataEkskulView(),
      ),
    ];
    return Scaffold(
      body: SafeArea(
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
                                      borderRadius: BorderRadius.circular(20.0),
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
                                                color: AppColors.inversePrimary,
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
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackbar);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang Admin',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Apa yang ingin anda lakukan hari ini?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.035),
                  SizedBox(
                    width: width * 0.9,
                    height: height * 0.6,
                    child: ListView.separated(
                      itemBuilder: (context, index) => CardActivity(
                        image: images[index],
                        title: title[index],
                        page: pages[index],
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: height * 0.01),
                      itemCount: title.length,
                    ),
                  ),
                  SizedBox(height: height * 0.045),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        color: AppColors.tertiary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
