import 'package:flutter/material.dart';

import '../../../common/widget/appbar/basic_appbar.dart';

class ProfileTeacher extends StatelessWidget {
  const ProfileTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: false,
              isLogout: true,
              isProfileViewed: false,
            ),
          ],
        ),
      ),
    );
  }
}
