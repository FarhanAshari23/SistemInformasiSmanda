import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageEkskul/widgets/card_ekskul_edit.dart';

import '../../../core/configs/assets/app_images.dart';

class EditDataEkskulView extends StatelessWidget {
  const EditDataEkskulView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => EkskulCubit()..displayEkskul(),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true, isProfileViewed: false),
              const Text(
                'Pilih Ekskul yang ingin diubah:',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: height * 0.03),
              BlocBuilder<EkskulCubit, EkskulState>(
                builder: (context, state) {
                  if (state is EkskulLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EkskulLoaded) {
                    if (state.ekskul.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      );
                    } else {
                      return Expanded(
                        child: GridView.builder(
                          itemCount: state.ekskul.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: width * 0.025,
                            mainAxisSpacing: 12.0,
                            mainAxisExtent: height * 0.315,
                          ),
                          itemBuilder: (context, index) => CardEkskulEdit(
                            ekskul: state.ekskul[index],
                          ),
                        ),
                      );
                    }
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
