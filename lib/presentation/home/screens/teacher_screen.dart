import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_search.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_teacher_role.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/list_staff_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/organization_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/search_screen_teacher.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_view.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardTeacherRole(
                  image: AppImages.structural,
                  title: 'Dewan Pimpinan Sekolah',
                  nextPage: OrganizationView(),
                ),
                CardTeacherRole(
                  image: AppImages.teaching,
                  title: 'Daftar Tenaga Pengajar',
                  nextPage: TeacherView(),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardTeacherRole(
                  image: AppImages.staff,
                  title: 'Daftar Staff Sekolah',
                  nextPage: ListStaffView(),
                ),
                CardSearch(
                  nextPage: SearchScreenTeacher(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
