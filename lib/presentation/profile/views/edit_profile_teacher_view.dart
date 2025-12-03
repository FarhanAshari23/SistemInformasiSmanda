import 'package:flutter/material.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../domain/entities/auth/teacher.dart';

class EditProfileTeacherView extends StatelessWidget {
  final TeacherEntity? teacher;
  const EditProfileTeacherView({
    super.key,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            BasicAppbar(isBackViewed: true, isProfileViewed: false),
          ],
        ),
      ),
    );
  }
}
