import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/ekskul/ekskul_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../common/bloc/ekskul/select_ekskul_cubit.dart';
import '../../../common/bloc/ekskul/get_student_ekskul_cubit.dart';
import '../../../common/bloc/ekskul/get_student_ekskul_state.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/entities/ekskul/member.dart';

class EkskulSelectionView extends StatefulWidget {
  final int studentId;
  const EkskulSelectionView({
    super.key,
    required this.studentId,
  });

  @override
  State<EkskulSelectionView> createState() => _EkskulSelectionViewState();
}

class _EkskulSelectionViewState extends State<EkskulSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EkskulCubit()..displayEkskul(),
          ),
          BlocProvider(
            create: (context) => SelectEkskulCubit(),
          ),
          BlocProvider(
            create: (context) =>
                GetStudentEkskulCubit()..getStudentEkskul(widget.studentId),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GetStudentEkskulCubit, GetStudentEkskulState>(
              listener: (context, state) {
                if (state is GetStudentEkskulLoaded) {
                  final allEkskulState = context.read<EkskulCubit>().state;

                  if (allEkskulState is EkskulLoaded) {
                    final initialSelected = allEkskulState.ekskul.where((e) {
                      return state.ekskuls
                          .any((m) => m.ekskulName == e.nameEkskul);
                    }).toList();

                    context
                        .read<SelectEkskulCubit>()
                        .setInitialSelected(initialSelected);
                  }
                }
              },
            ),
            BlocListener<EkskulCubit, EkskulState>(
              listener: (context, state) {
                if (state is EkskulLoaded) {
                  final studentState =
                      context.read<GetStudentEkskulCubit>().state;
                  if (studentState is GetStudentEkskulLoaded) {
                    final initialSelected = state.ekskul.where((e) {
                      return studentState.ekskuls
                          .any((m) => m.ekskulName == e.nameEkskul);
                    }).toList();
                    context
                        .read<SelectEkskulCubit>()
                        .setInitialSelected(initialSelected);
                  }
                }
              },
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
                Container(),
                const SizedBox(height: 8),
                BlocBuilder<GetStudentEkskulCubit, GetStudentEkskulState>(
                  builder: (context, state) {
                    if (state is GetStudentEkskulLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetStudentEkskulLoaded) {
                      List<MemberEntity> mainRole = state.ekskuls
                          .where((element) => element.role != "Anggota")
                          .toList();
                      if (mainRole.isEmpty) {
                        return const Center(
                          child: Text(
                            'Anda tidak sedang menjabat ekskul apapun',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else {
                        return Flexible(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final role = mainRole[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${role.role} ${role.ekskulName}",
                                  style: const TextStyle(
                                    color: AppColors.inversePrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemCount: mainRole.length,
                          ),
                        );
                      }
                    }
                    if (state is GetStudentEkskulFailure) {
                      if (state.errorMessage ==
                          "Something error: (null):(404):Data murid tidak ditemukan") {
                        return const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            'Anda tidak sedang menjabat ekskul apapun',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else {
                        return Text(state.errorMessage);
                      }
                    }
                    return Container();
                  },
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
                                List<EkskulEntity> filterEkskul =
                                    state.ekskul.where((ekskul) {
                                  if (ekskul.members == null ||
                                      ekskul.members!.isEmpty) {
                                    return true;
                                  }

                                  final memberTerkait = ekskul.members!
                                      .cast<MemberEntity?>()
                                      .firstWhere(
                                        (m) => m?.id == widget.studentId,
                                        orElse: () => null,
                                      );

                                  if (memberTerkait == null) {
                                    return true;
                                  } else {
                                    return memberTerkait.role == "Anggota";
                                  }
                                }).toList();
                                return ListView.builder(
                                  itemCount: filterEkskul.length,
                                  scrollDirection: Axis.vertical,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  itemBuilder: (context, index) {
                                    final ekskul = filterEkskul[index];

                                    final isSelected = selectedEkskul.any((e) =>
                                        e.nameEkskul == ekskul.nameEkskul);
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ekskul.nameEkskul ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
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
                                padding: const EdgeInsets.only(bottom: 8.0),
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
      ),
    );
  }
}

class DisplayEkskul {
  final String namaEkskul;
  final bool isCustom;

  DisplayEkskul({required this.namaEkskul, this.isCustom = false});
}
