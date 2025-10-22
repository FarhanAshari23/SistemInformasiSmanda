import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/bloc/select_subject_cubit.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/schedule/activity.dart';

class SelectMengajarView extends StatelessWidget {
  final List<ActivityEntity> activities;
  const SelectMengajarView({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SelectSubjectCubit(),
        child: BlocBuilder<SelectSubjectCubit, List<String>>(
          builder: (context, selectedActivities) {
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
                          'Pilih pelajaran yang diajar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        CustomInkWell(
                          borderRadius: 12,
                          defaultColor: selectedActivities.isEmpty
                              ? Colors.white24
                              : AppColors.primary,
                          onTap: () {
                            if (selectedActivities.isEmpty) return;
                            Navigator.pop(context, selectedActivities);
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: activities.length,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        final isSelected =
                            selectedActivities.contains(activity.name);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: CustomInkWell(
                            borderRadius: 16,
                            defaultColor: isSelected
                                ? AppColors.secondary
                                : AppColors.primary,
                            onTap: () {
                              context
                                  .read<SelectSubjectCubit>()
                                  .toggleSubject(activity.name);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                activity.name,
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
