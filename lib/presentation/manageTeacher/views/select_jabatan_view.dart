import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/roles/get_roles_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/roles/get_roles_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/bloc/select_jabatan_cubit.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';

class SelectJabatanView extends StatelessWidget {
  const SelectJabatanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SelectJabatanCubit(),
          ),
          BlocProvider(
            create: (context) => GetRolesCubit()..displayRoles(),
          ),
        ],
        child: BlocBuilder<SelectJabatanCubit, List<String>>(
          builder: (context, selectedRoles) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BasicAppbar(
                    isBackViewed: true,
                    isProfileViewed: false,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih tugas tambahan:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        CustomInkWell(
                          borderRadius: 12,
                          defaultColor: selectedRoles.isEmpty
                              ? Colors.white24
                              : AppColors.primary,
                          onTap: () {
                            if (selectedRoles.isEmpty) return;
                            Navigator.pop(context, selectedRoles);
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
                  ),
                  BlocBuilder<GetRolesCubit, GetRolesState>(
                    builder: (context, state) {
                      if (state is GetRolesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is GetRolesLoaded) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.roles.length,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemBuilder: (context, index) {
                              final roles = state.roles[index];
                              final isSelected =
                                  selectedRoles.contains(roles.name);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: CustomInkWell(
                                  borderRadius: 16,
                                  defaultColor: isSelected
                                      ? AppColors.secondary
                                      : AppColors.primary,
                                  onTap: () {
                                    context
                                        .read<SelectJabatanCubit>()
                                        .toggleJabatan(roles.name);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      roles.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.inversePrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
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
