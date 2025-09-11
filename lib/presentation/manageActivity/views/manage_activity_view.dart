import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/activities/get_activities_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class ManageActivityView extends StatelessWidget {
  const ManageActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => GetActivitiesCubit()..displayActivites(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'Daftar kegiatan:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: BlocBuilder<GetActivitiesCubit, GetActivitiesState>(
                  builder: (context, state) {
                    if (state is GetActivitiesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is GetActivitiesLoaded) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          if (index == state.activities.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              child: CustomInkWell(
                                borderRadius: 16,
                                defaultColor: AppColors.primary,
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          final activity = state.activities[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.primary,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              activity.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.inversePrimary,
                              ),
                            ),
                          );
                        },
                        itemCount: state.activities.length + 1,
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
