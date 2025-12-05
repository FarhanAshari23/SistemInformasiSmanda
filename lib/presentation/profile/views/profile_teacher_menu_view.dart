import 'package:flutter/widgets.dart';

import '../../../common/widget/card/card_basic.dart';
import '../../../core/configs/assets/app_images.dart';

class ProfileTeacherMenuView extends StatelessWidget {
  const ProfileTeacherMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardBasic(
                image: AppImages.attendance,
                onpressed: () {},
                title: 'Absen Masuk',
              ),
              CardBasic(
                image: AppImages.attendance,
                onpressed: () {},
                title: 'Absen Pulang',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardBasic(
                image: AppImages.verification,
                onpressed: () {},
                title: 'Data Absen Masuk',
              ),
              CardBasic(
                image: AppImages.verification,
                onpressed: () {},
                title: 'Data Absen Pulang',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
