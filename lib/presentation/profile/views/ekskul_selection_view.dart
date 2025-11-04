import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_state.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../common/bloc/ekskul/select_ekskul_cubit.dart';

class EkskulSelectionView extends StatefulWidget {
  final List<String> initialEkskul;
  const EkskulSelectionView({
    super.key,
    required this.initialEkskul,
  });

  @override
  State<EkskulSelectionView> createState() => _EkskulSelectionViewState();
}

class _EkskulSelectionViewState extends State<EkskulSelectionView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EkskulCubit()..displayEkskul(),
          ),
          BlocProvider(
            create: (context) =>
                SelectEkskulCubit()..setInitialSelected(widget.initialEkskul),
          ),
        ],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pilih ekskul',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontSize: 24,
                  ),
                ),
              ),
              BlocBuilder<EkskulCubit, EkskulState>(
                builder: (context, state) {
                  if (state is EkskulLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is EkskulLoaded) {
                    final fetchedEkskul = state.ekskul
                        .map(
                          (e) => DisplayEkskul(
                            namaEkskul: e.namaEkskul,
                            isCustom: false,
                          ),
                        )
                        .toList();
                    final extraEkskul = (widget.initialEkskul)
                        .where((nama) => !fetchedEkskul.any(
                              (e) =>
                                  e.namaEkskul.toLowerCase() ==
                                  nama.toLowerCase(),
                            ))
                        .map((nama) =>
                            DisplayEkskul(namaEkskul: nama, isCustom: true))
                        .toList();
                    final combinedEkskul = [...extraEkskul, ...fetchedEkskul];
                    return Expanded(
                      child: Stack(
                        children: [
                          BlocBuilder<SelectEkskulCubit, List<String>>(
                            builder: (context, selectedEkskul) {
                              return GridView.builder(
                                itemCount: combinedEkskul.length,
                                scrollDirection: Axis.vertical,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  mainAxisExtent: height * 0.25,
                                ),
                                itemBuilder: (context, index) {
                                  final ekskul = combinedEkskul[index];
                                  final isSelected = selectedEkskul
                                      .contains(ekskul.namaEkskul);
                                  return CustomInkWell(
                                    onTap: () {
                                      if (ekskul.isCustom) return;
                                      context
                                          .read<SelectEkskulCubit>()
                                          .toggleEkskul(ekskul.namaEkskul);
                                    },
                                    borderRadius: 8,
                                    defaultColor: ekskul.isCustom
                                        ? Colors.red
                                        : isSelected
                                            ? AppColors.primary
                                            : AppColors.secondary,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ekskul.namaEkskul,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CustomInkWell(
                                borderRadius: 8,
                                defaultColor: AppColors.primary,
                                onTap: () {
                                  final selected =
                                      context.read<SelectEkskulCubit>().state;
                                  final customEkskul = combinedEkskul
                                      .where((element) => element.isCustom)
                                      .map((e) => e.namaEkskul)
                                      .toList();
                                  final endResult = {
                                    ...customEkskul,
                                    ...selected,
                                  }.toList();
                                  Navigator.pop(
                                    context,
                                    endResult,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 24,
                                  ),
                                  child: const Text(
                                    'Pilih',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.inversePrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
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

class DisplayEkskul {
  final String namaEkskul;
  final bool isCustom;

  DisplayEkskul({required this.namaEkskul, this.isCustom = false});
}
