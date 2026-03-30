import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../../../common/bloc/ekskul/ekskul_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../common/bloc/ekskul/select_ekskul_cubit.dart';
import '../../../domain/entities/ekskul/member.dart';

class EkskulSelectionView extends StatefulWidget {
  final List<MemberEntity>? initialEkskul;
  const EkskulSelectionView({
    super.key,
    this.initialEkskul,
  });

  @override
  State<EkskulSelectionView> createState() => _EkskulSelectionViewState();
}

class _EkskulSelectionViewState extends State<EkskulSelectionView> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<MemberEntity> mainRole = [];
    if (widget.initialEkskul != null) {
      mainRole = widget.initialEkskul!
          .where((element) => element.role != "Anggota")
          .toList as List<MemberEntity>;
    }
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EkskulCubit()..displayEkskul(),
          ),
          BlocProvider(
            create: (context) => SelectEkskulCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Jabatan Ekskul Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    fontSize: 24,
                  ),
                ),
              ),
              widget.initialEkskul != null
                  ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final role = mainRole[index];
                        return Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${role.role} ${role.ekskulName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: mainRole.length,
                    )
                  : const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        'Anda tidak sedang menjabat ekskul apapun',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
              const SizedBox(height: 8),
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
                    return Expanded(
                      child: Stack(
                        children: [
                          BlocBuilder<SelectEkskulCubit, List<EkskulEntity>>(
                            builder: (context, selectedEkskul) {
                              return GridView.builder(
                                itemCount: state.ekskul.length,
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
                                  final ekskul = state.ekskul[index];
                                  final isSelected =
                                      selectedEkskul.contains(ekskul);
                                  return CustomInkWell(
                                    onTap: () {
                                      context
                                          .read<SelectEkskulCubit>()
                                          .toggleEkskul(ekskul);
                                    },
                                    borderRadius: 8,
                                    defaultColor: isSelected
                                        ? AppColors.primary
                                        : AppColors.secondary,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ekskul.nameEkskul ?? '',
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

                                  Navigator.pop(
                                    context,
                                    selected,
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
