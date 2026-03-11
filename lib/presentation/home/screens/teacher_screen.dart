import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_search.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_teacher_role.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/search_screen_teacher.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_view.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardSearch(
                  nextPage: SearchScreenTeacher(),
                ),
                CardTeacherRole(
                  image: AppImages.teaching,
                  title: 'Daftar Tenaga Pengajar',
                  nextPage: TeacherView(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
