import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/get_all_kelas_cubit.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/add_data_ekskul_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/views/edit_data_ekskul_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/views/add_news_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/views/edit_news_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/edit_student_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/views/register_student_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/add_teacher_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/edit_teacher_view.dart';
import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../auth/views/login_view.dart';
import '../../manageActivity/views/manage_activity_view.dart';
import '../../manageAttendance/views/scan_barcode_view.dart';
import '../../manageAttendance/views/see_data_attandance.dart';
import '../../manageAttendance/widgets/card_feature.dart';
import '../../manageJabatan/views/manage_jabatan_views.dart';
import '../../manageSchedule/views/add_schedule_view.dart';
import '../../manageSchedule/views/edit_schedule_view.dart';

class HomeViewAdmin extends StatelessWidget {
  const HomeViewAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> title = [
      'Scan barcode absen',
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
      'Daftar kegiatan',
      'Daftar jabatan',
    ];
    List<String> images = [
      AppImages.camera,
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
      AppImages.subjectsIcon,
      AppImages.roleIcon,
    ];
    List<Widget> pages = [
      const ScanBarcodeView(),
      const SeeDataAttandance(),
      const RegisterStudentView(),
      BlocProvider(
        create: (context) => GetAllKelasCubit()..displayAll(),
        child: const EditStudentView(),
      ),
      const AddTeacherView(),
      const EditTeacherView(),
      const AddNewsView(),
      const EditNewsView(),
      const AddDataEkskulView(),
      const EditDataEkskulView(),
      const AddScheduleView(),
      const EditScheduleView(),
      const ManageActivityView(),
      const ManageJabatanViews(),
    ];
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: SafeArea(
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                AppNavigator.pushReplacement(context, LoginView());
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BasicAppbar(
                  isBackViewed: false,
                  isLogout: true,
                  isProfileViewed: false,
                ),
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
                const SizedBox(height: 16),
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
                      return CardFeature(
                        onpressed: () =>
                            AppNavigator.push(context, pages[index]),
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
      ),
    );
  }
}
