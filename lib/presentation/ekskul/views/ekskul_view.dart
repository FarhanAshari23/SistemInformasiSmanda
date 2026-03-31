import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../common/bloc/ekskul/ekskul_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../widgets/card_ekskul.dart';
import 'ekskul_detail_view.dart';

class EkskulScreen extends StatelessWidget {
  const EkskulScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 48,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: height * 0.3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => AppNavigator.push(
                        context,
                        EkskulDetail(
                          ekskul: state.ekskul[index],
                        ),
                      ),
                      child: CardEkskul(
                        ekskul: state.ekskul[index],
                      ),
                    );
                  },
                  itemCount: state.ekskul.length,
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
