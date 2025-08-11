import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_duabelas_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/widget/loading/list_kelas_loading.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../bloc/kelas/kelas_navigation.dart';
import '../../bloc/kelas/stundets_cubit.dart';

class ListKelasDuabelas extends StatelessWidget {
  const ListKelasDuabelas({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => KelasDuabelasCubit()..displayDuabelas(),
      child: SizedBox(
        width: double.infinity,
        height: height * 0.05,
        child: BlocBuilder<KelasDuabelasCubit, KelasDisplayState>(
          builder: (context, state) {
            if (state is KelasDisplayLoading) {
              return const ListKelasLoading();
            }
            if (state is KelasDisplayLoaded) {
              return BlocProvider(
                create: (context) => KelasNavigationCubit(),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CustomInkWell(
                      onTap: () {
                        context.read<KelasNavigationCubit>().changeColor(index);
                        context.read<StudentsDisplayCubit>().displayStudents(
                            params: state.kelas[index].data()['value']);
                      },
                      borderRadius: 12,
                      defaultColor:
                          context.watch<KelasNavigationCubit>().state == index
                              ? AppColors.primary
                              : AppColors.tertiary,
                      child: SizedBox(
                        width: width * 0.2,
                        height: height * 0.035,
                        child: Center(
                          child: Text(
                            state.kelas[index].data()['value'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color:
                                  context.watch<KelasNavigationCubit>().state ==
                                          index
                                      ? AppColors.tertiary
                                      : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(width: width * 0.01),
                  itemCount: state.kelas.length,
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
