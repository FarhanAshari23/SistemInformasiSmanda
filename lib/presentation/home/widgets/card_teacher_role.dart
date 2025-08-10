import 'package:flutter/widgets.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => AppNavigator.push(context, nextPage),
      child: Container(
        width: width * 0.435,
        height: height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: width * 0.235,
                height: height * 0.1,
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
                padding: const EdgeInsets.all(16),
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
