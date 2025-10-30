import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_news.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/news/create_news.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/widgets/news_detail.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../home/views/home_view_admin.dart';

class AckNewsView extends StatelessWidget {
  final NewsModel createNewsReq;
  const AckNewsView({
    super.key,
    required this.createNewsReq,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              AppNavigator.push(
                context,
                const SuccesPage(
                  page: HomeViewAdmin(),
                  title: "Data Pengumuman Berhasil Ditambahkan",
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const Text(
                  'APAKAH PENGUMUMAN\nSUDAH SESUAI?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tampilan di List Pengumuman',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      CardNews(
                        onPressed: () {},
                        title: createNewsReq.title,
                        from: createNewsReq.from,
                        to: createNewsReq.to,
                      ),
                      SizedBox(height: height * 0.03),
                      const Text(
                        'Tampilan Detail Pengumuman',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      NewsDetail(
                        title: createNewsReq.title,
                        createdAt: createNewsReq.createdAt,
                        from: createNewsReq.from,
                        to: createNewsReq.to,
                        content: createNewsReq.content,
                      ),
                      SizedBox(height: height * 0.02),
                      Center(
                        child: Builder(builder: (context) {
                          return BasicButton(
                            onPressed: () {
                              context.read<ButtonStateCubit>().execute(
                                    usecase: CreateNewsUseCase(),
                                    params: createNewsReq,
                                  );
                            },
                            title: 'Simpan',
                          );
                        }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
