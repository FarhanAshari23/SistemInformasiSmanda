import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_primary.dart';

class ManageObjectView extends StatelessWidget {
  final String title;
  final String namaFiturSatu;
  final String namaFiturDua;
  final Widget pageSatu;
  final Widget pageDua;
  const ManageObjectView({
    super.key,
    required this.title,
    required this.namaFiturSatu,
    required this.namaFiturDua,
    required this.pageSatu,
    required this.pageDua,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.09),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardPrimary(
                        title: namaFiturSatu,
                        widget: pageSatu,
                      ),
                      CardPrimary(
                        title: namaFiturDua,
                        widget: pageDua,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
