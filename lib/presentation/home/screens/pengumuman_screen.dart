import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_news.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/news_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/pengumuman_detail_view.dart';

import '../bloc/news_state.dart';

class PengumumanScreen extends StatelessWidget {
  const PengumumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => NewsCubit()..displayNews(),
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is NewsLoaded) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
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
                      title: state.news[index].title,
                      from: state.news[index].from,
                      to: state.news[index].to,
                    );
                  },
                ),
              );
            }
            if (state is NewsFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
