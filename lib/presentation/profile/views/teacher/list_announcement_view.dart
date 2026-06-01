import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/helper/app_navigation.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../common/widget/card/card_news.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../news/bloc/news_cubit.dart';
import '../../../news/bloc/news_state.dart';
import '../../../news/views/pengumuman_detail_screen.dart';

class ListAnnouncementView extends StatelessWidget {
  final int teacherId;
  const ListAnnouncementView({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => NewsCubit()..displayNewsByTeacher(teacherId),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const BasicAppbar(isBackViewed: true),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Text(
                  'Pengumuman Saya:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: height * 0.01),
                        itemCount: state.news.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return BlocProvider.value(
                            value: context.read<NewsCubit>(),
                            child: CardNews(
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
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is NewsFailure) {
                    if (state.errorMessage ==
                        "Something error: type 'Null' is not a subtype of type 'List<dynamic>' in type cast") {
                      return Column(
                        children: [
                          Image.asset(
                            AppImages.notfound,
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Belum ada pengumuman",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text(state.errorMessage);
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
