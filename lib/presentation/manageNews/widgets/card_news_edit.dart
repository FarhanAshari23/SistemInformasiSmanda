import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/news/delete_news.dart';

import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';
import '../../home/bloc/news_cubit.dart';
import '../views/edit_news_view_detail.dart';

class CardNewsEdit extends StatelessWidget {
  final NewsEntity news;
  const CardNewsEdit({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: bodyHeight * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.inversePrimary,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: bodyHeight * 0.01),
                SizedBox(
                  width: width * 0.7,
                  height: bodyHeight * 0.06,
                  child: Text(
                    'Dari ${news.from} untuk ${news.to}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -(bodyHeight * 0.001),
          right: -(width * 0.001),
          child: PopupMenuButton(
            onSelected: (String value) {
              if (value == 'Edit') {
                AppNavigator.push(
                  context,
                  BlocProvider.value(
                    value: context.read<NewsCubit>(),
                    child: EditNewsViewDetail(
                      news: news,
                    ),
                  ),
                );
              } else if (value == 'Hapus') {
                final outerContext = context;
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: AppColors.inversePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        width: width * 0.7,
                        height: bodyHeight * 0.55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.6,
                              height: bodyHeight * 0.3,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.splashDelete),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              'Apakah anda yakin ingin menghapus data ${news.title}?',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: bodyHeight * 0.02),
                            BasicButton(
                              onPressed: () async {
                                var delete = await sl<DeleteNewsUsecase>()
                                    .call(params: news.uIdNews);
                                return delete.fold(
                                  (error) {
                                    var snackbar = const SnackBar(
                                      content: Text(
                                          "Gagal Menghapus Murid, Coba Lagi"),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  (r) {
                                    var snackbar = const SnackBar(
                                      content: Text("Data Berhasil Dihapus"),
                                    );
                                    outerContext
                                        .read<NewsCubit>()
                                        .displayNews();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              title: 'Hapus',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Hapus',
                  child: Text(
                    'Hapus',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.inversePrimary,
                    ),
                  ),
                ),
              ];
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                ),
                color: AppColors.secondary,
              ),
              child: const Center(
                child: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.inversePrimary,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
