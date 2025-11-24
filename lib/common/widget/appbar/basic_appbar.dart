import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/helper/extract_name.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/profile_info_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/views/profile_view.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../photo/network_photo.dart';

class BasicAppbar extends StatelessWidget {
  final bool isBackViewed;
  final bool isProfileViewed;
  const BasicAppbar({
    super.key,
    required this.isBackViewed,
    required this.isProfileViewed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String greeting;
    int hour = now.hour;
    if (hour < 10) {
      greeting = "Pagi";
    } else if (hour < 16) {
      greeting = "Siang";
    } else if (hour < 19) {
      greeting = "Sore";
    } else {
      greeting = "Malam";
    }
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: height * 0.09,
              color: AppColors.secondary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: isBackViewed,
                      child: CustomInkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: 8,
                        defaultColor: AppColors.tertiary,
                        child: SizedBox(
                          width: width * 0.125,
                          height: height * 0.06,
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.inversePrimary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isProfileViewed,
                      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                        builder: (context, state) {
                          if (state is ProfileInfoLoading) {
                            return Row(
                              children: [
                                const Text(
                                  'Tunggu Sebentar...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.inversePrimary,
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                GestureDetector(
                                  onTap: () => AppNavigator.push(
                                    context,
                                    const ProfileView(),
                                  ),
                                  child: Container(
                                    width: width * 0.105,
                                    height: height * 0.065,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.tertiary,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          if (state is ProfileInfoLoaded) {
                            String nickname =
                                extractName(state.userEntity.nama!);
                            return Row(
                              children: [
                                Text(
                                  '$greeting $nickname!',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.inversePrimary,
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                GestureDetector(
                                  onTap: () => AppNavigator.push(
                                    context,
                                    const ProfileView(),
                                  ),
                                  child: NetworkPhoto(
                                    width: width * 0.105,
                                    height: height * 0.065,
                                    shape: BoxShape.circle,
                                    fallbackAsset: state.userEntity.gender == 1
                                        ? AppImages.boyStudent
                                        : AppImages.girlStudent,
                                    imageUrl: DisplayImage.displayImageStudent(
                                        state.userEntity.nama ?? '',
                                        state.userEntity.nisn ?? ''),
                                  ),
                                ),
                              ],
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
            Positioned(
              top: 30,
              left: width * 0.4,
              child: Image.asset(
                AppImages.logoSMA,
                width: width * 0.2,
                height: height * 0.095,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
