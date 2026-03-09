import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/news/news.dart';

class PengumumanDetailView extends StatelessWidget {
  final NewsEntity newsEntity;
  const PengumumanDetailView({
    super.key,
    required this.newsEntity,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(newsEntity.createdAt!);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondary,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.345,
                              height: height * 0.1,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                ),
                                color: AppColors.tertiary,
                              ),
                              child: const Center(
                                child: Text(
                                  "Pengumuman",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                                top: 12,
                                left: 8,
                              ),
                              child: SizedBox(
                                width: width * 0.5,
                                height: height * 0.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.inversePrimary,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Text(
                                      newsEntity.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.inversePrimary,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: height * 0.525,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                Text(
                                  'Dari ${newsEntity.teacherName} untuk ${newsEntity.isGlobal! ? "Semua Kelas" : newsEntity.className!}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.inversePrimary,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  newsEntity.description ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.inversePrimary,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
