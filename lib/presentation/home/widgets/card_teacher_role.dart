import 'package:flutter/widgets.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardTeacherRole extends StatelessWidget {
  final Widget nextPage;
  final String image;
  final String title;
  const CardTeacherRole({
    super.key,
    required this.image,
    required this.title,
    required this.nextPage,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CustomInkWell(
      onTap: () => AppNavigator.push(context, nextPage),
      borderRadius: 8,
      defaultColor: AppColors.secondary,
      child: SizedBox(
        width: width * 0.45,
        height: width * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: width * 0.2,
                height: width * 0.2,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                  ),
                  color: AppColors.tertiary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(image),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                  bottom: 12,
                  top: 12,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
