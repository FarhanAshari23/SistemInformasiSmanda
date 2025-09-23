import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/profile_info_cubit.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../views/edit_profile_view.dart';

class CardProfile extends StatelessWidget {
  final UserEntity user;
  const CardProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      padding: const EdgeInsets.only(
        bottom: 18,
        top: 18,
        right: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondary,
      ),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.3,
            height: height * 0.15,
            child: CachedNetworkImage(
              imageUrl:
                  DisplayImage.displayImageStudent(user.nama!, user.nisn!),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Image.asset(
                user.gender == 1 ? AppImages.boyStudent : AppImages.girlStudent,
              ),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 19, left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.45,
                      height: height * 0.055,
                      child: Text(
                        user.nama!,
                        style: const TextStyle(
                          color: AppColors.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      user.kelas!,
                      style: const TextStyle(
                        color: AppColors.inversePrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CustomInkWell(
                  borderRadius: 999,
                  defaultColor: AppColors.primary,
                  onTap: () => AppNavigator.push(
                    context,
                    BlocProvider.value(
                      value: context.read<ProfileInfoCubit>(),
                      child: EditProfileView(user: user),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
