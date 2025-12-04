import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/presentation/ekskul/views/ekskul_detail.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/widgets/card_ekskul.dart';
import 'package:stacked_listview/stacked_listview.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';

class EkskulScreen extends StatelessWidget {
  const EkskulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => EkskulCubit()..displayEkskul(),
        child: BlocBuilder<EkskulCubit, EkskulState>(
          builder: (context, state) {
            if (state is EkskulLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is EkskulLoaded) {
              if (state.ekskul.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.notfound,
                        width: height * 0.3,
                        height: height * 0.3,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Data ekskul masih kosong",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return StackedListView(
                  padding: EdgeInsets.only(
                      bottom: height * 0.15, top: height * 0.07),
                  itemExtent: width * 0.475,
                  itemCount: state.ekskul.length,
                  scrollDirection: Axis.horizontal,
                  builder: (context, index) {
                    return GestureDetector(
                      onTap: () => AppNavigator.push(
                        context,
                        EkskulDetail(
                          ekskul: state.ekskul[index],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 4,
                          right: index == state.ekskul.length - 1 ? 0 : 4,
                        ),
                        child: CardEkskul(
                          ekskul: state.ekskul[index],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}
