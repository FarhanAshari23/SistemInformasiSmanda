import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/news_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/widgets/card_news_edit.dart';

import '../../home/bloc/news_state.dart';

class EditNewsView extends StatelessWidget {
  const EditNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'DATA PENGUMUMAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  BlocProvider(
                    create: (context) => NewsCubit()..displayNews(),
                    child: SizedBox(
                      width: double.infinity,
                      height: height * 0.7,
                      child: BlocBuilder<NewsCubit, NewsState>(
                        builder: (context, state) {
                          if (state is NewsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is NewsLoaded) {
                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: height * 0.01),
                              itemCount: state.news.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return CardNewsEdit(
                                  news: state.news[index],
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
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
