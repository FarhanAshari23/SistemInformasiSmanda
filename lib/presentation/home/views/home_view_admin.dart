import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/dialog/basic_dialog.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../auth/views/login_view.dart';
import '../../admin/activity/views/manage_activity_view.dart';
import '../../admin/attendance/views/see_all_data_attandance_students.dart';
import '../../../common/widget/card/card_basic.dart';
import '../../admin/attendance/views/see_all_data_attendance_teacher.dart';
import '../../admin/ekskul/views/add_data_ekskul_view.dart';
import '../../admin/ekskul/views/edit_data_ekskul_view.dart';
import '../../admin/jabatan/views/manage_jabatan_views.dart';
import '../../admin/news/views/add_news_view.dart';
import '../../admin/news/views/edit_news_view.dart';
import '../../admin/schedule/views/add_schedule_view.dart';
import '../../admin/schedule/views/edit_schedule_view.dart';
import '../../admin/student/views/edit_student_view.dart';
import '../../admin/student/views/register_student_view.dart';
import '../../admin/teacher/views/add_teacher_view.dart';
import '../../admin/teacher/views/edit_teacher_view.dart';

class HomeViewAdmin extends StatelessWidget {
  const HomeViewAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> title = [
      'Lihat absen guru',
      'Lihat absen siswa',
      'Registrasi data siswa',
      'Edit data siswa',
      'Tambah data guru',
      'Edit data guru',
      'Buat pengumuman',
      'Edit pengumuman',
      'Tambah data ekskul',
      'Edit data ekskul',
      'Tambah data kelas',
      'Edit data kelas',
      'Daftar kegiatan',
      'Daftar tugas tambahan',
    ];
    List<String> images = [
      AppImages.teacherAttendance,
      AppImages.studentAttendance,
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
      const SeeAllDataAttendanceTeacher(),
      const SeeAllDataAttandanceStudents(),
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
                  showLogo: true,
                  isAdmin: true,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: title.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: height * 0.25,
                        ),
                        itemBuilder: (context, index) {
                          return CardBasic(
                            onpressed: () =>
                                AppNavigator.push(context, pages[index]),
                            title: title[index],
                            image: images[index],
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 12,
                            left: height * 0.25,
                          ),
                          child: Builder(builder: (context) {
                            return BasicButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) {
                                  return BasicDialog(
                                    buttonTitle: 'Keluar',
                                    mainTitle:
                                        'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                                    splashImage: AppImages.splashLogout,
                                    onPressed: () {
                                      context.read<ButtonStateCubit>().execute(
                                            usecase: LogoutUsecase(),
                                          );
                                    },
                                  );
                                },
                              ),
                              title: "Keluar",
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
