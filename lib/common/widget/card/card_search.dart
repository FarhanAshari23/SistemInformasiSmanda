import 'package:flutter/widgets.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class CardSearch extends StatelessWidget {
  final Widget nextPage;
  const CardSearch({
    super.key,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      borderRadius: 16,
      onTap: () => AppNavigator.push(context, nextPage),
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.435,
        height: height * 0.25,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  width: width * 0.2,
                  height: height * 0.095,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.search),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              const Text(
                'Cari Berdasarkan Nama',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
