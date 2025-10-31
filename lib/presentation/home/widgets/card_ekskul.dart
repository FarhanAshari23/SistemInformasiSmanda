import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardEkskul extends StatelessWidget {
  final EkskulEntity ekskul;
  const CardEkskul({
    super.key,
    required this.ekskul,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ekskul.namaEkskul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.inversePrimary,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: ekskul.pembina.nama.length > 25
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.manage_accounts,
                  color: AppColors.inversePrimary,
                ),
                const SizedBox(width: 3),
                const Text(
                  ': ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.start,
                ),
                Expanded(
                  child: Text(
                    ekskul.pembina.nama,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: ekskul.pembina.nama.length > 25
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.groups_2,
                  color: AppColors.inversePrimary,
                ),
                const SizedBox(width: 3),
                const Text(
                  ': ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.start,
                ),
                Expanded(
                  child: Text(
                    '${ekskul.anggota.length} anggota',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inversePrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
