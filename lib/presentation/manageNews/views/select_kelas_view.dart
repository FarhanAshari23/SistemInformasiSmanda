import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/kelas/kelas.dart';
import '../bloc/select_kelas_cubit.dart';

class SelectKelasView extends StatelessWidget {
  final List<KelasEntity> classes;
  const SelectKelasView({
    super.key,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SelectKelasCubit(),
        child: BlocBuilder<SelectKelasCubit, List<KelasEntity>>(
          builder: (context, selectedKelas) {
            final isAllSelected = selectedKelas.length == classes.length;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BasicAppbar(isBackViewed: true),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih kelas:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomInkWell(
                              borderRadius: 12,
                              defaultColor: !isAllSelected
                                  ? Colors.white24
                                  : AppColors.primary,
                              onTap: () {
                                if (isAllSelected) {
                                  context.read<SelectKelasCubit>().clearAll();
                                } else {
                                  context
                                      .read<SelectKelasCubit>()
                                      .selectAll(classes);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Pilih Semua',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CustomInkWell(
                              borderRadius: 12,
                              defaultColor:
                                  selectedKelas.isEmpty && !isAllSelected
                                      ? Colors.white24
                                      : AppColors.primary,
                              onTap: () {
                                if (selectedKelas.isEmpty) return;
                                Navigator.pop(context, selectedKelas);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Pilih',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: classes.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final kelas = classes[index];
                        final isSelected = selectedKelas
                            .any((element) => element.id == kelas.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: CustomInkWell(
                            borderRadius: 16,
                            defaultColor:
                                isSelected ? AppColors.primary : Colors.white24,
                            onTap: () {
                              context
                                  .read<SelectKelasCubit>()
                                  .toggleKelas(kelas);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                kelas.className ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.inversePrimary
                                      : AppColors.secondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
