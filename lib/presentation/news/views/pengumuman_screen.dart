import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/card/card_news.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/news_cubit.dart';
import '../bloc/news_navigation_cubit.dart';
import '../bloc/news_state.dart';
import 'pengumuman_detail_screen.dart';

class PengumumanScreen extends StatelessWidget {
  final int classId;
  const PengumumanScreen({
    super.key,
    required this.classId,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NewsCubit()..displayNewsGlobal(),
          ),
          BlocProvider(
            create: (context) => NewsNavigationCubit(),
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<NewsNavigationCubit, int>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      2,
                      (index) {
                        const titles = ["Semua", "Berdasarkan Kelas"];
                        return CustomInkWell(
                          onTap: () {
                            context
                                .read<NewsNavigationCubit>()
                                .changeColor(index);
                            if (index == 0) {
                              context.read<NewsCubit>().displayNews();
                            }
                            if (index == 1) {
                              context
                                  .read<NewsCubit>()
                                  .displayNewsByClass(classId);
                            }
                          },
                          defaultColor: state == index
                              ? AppColors.primary
                              : AppColors.tertiary,
                          left: index == 0 ? 8 : 0,
                          right: index == 1 ? 8 : 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              titles[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is NewsLoaded) {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: height * 0.01),
                      itemCount: state.news.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return CardNews(
                          onPressed: () => AppNavigator.push(
                            context,
                            PengumumanDetailView(
                              newsEntity: state.news[index],
                            ),
                          ),
                          title: state.news[index].title ?? '',
                          from: state.news[index].teacherName ?? '',
                          to: state.news[index].isGlobal!
                              ? 'Semua Kelas'
                              : state.news[index].className ?? '',
                        );
                      },
                    ),
                  );
                }
                if (state is NewsFailure) {
                  if (state.errorMessage ==
                      "Something error: (null):(404):Data pengumuman tidak ditemukan") {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          Image.asset(
                            AppImages.emptyRegistrationChara,
                            width: 120,
                            height: 120,
                          ),
                          const Text(
                            'Data pengumuman tidak ditemukan',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
