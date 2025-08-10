import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../../core/configs/theme/app_colors.dart';

class NewsDetail extends StatelessWidget {
  final String title;
  final Timestamp createdAt;
  final String from;
  final String to;
  final String content;
  const NewsDetail({
    super.key,
    required this.title,
    required this.createdAt,
    required this.from,
    required this.to,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DateTime sekarang = DateTime.now();
    int tahun = sekarang.year;
    int bulan = sekarang.month;
    int tanggal = sekarang.day;
    return Container(
      width: double.infinity,
      height: height * 0.275,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width * 0.345,
                height: height * 0.085,
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
                padding: const EdgeInsets.only(right: 12, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$tanggal-$bulan-$tahun',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              height: height * 0.165,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Text(
                    '$from kepada $to:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.008),
                  Text(
                    content,
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
    );
  }
}
