import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/bloc/upload_image_state.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../data/models/auth/user_creation_req.dart';
import '../bloc/upload_image_cubit.dart';
import 'ack_add_account_view.dart';

class UploadImageView extends StatelessWidget {
  final UserCreationReq userCreationReq;
  const UploadImageView({
    super.key,
    required this.userCreationReq,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocProvider(
        create: (context) => UploadImageCubit(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              SizedBox(height: height * 0.1),
              BlocBuilder<UploadImageCubit, UploadImageState>(
                builder: (context, state) {
                  if (state is UploadImageInitial) {
                    return CustomInkWell(
                      borderRadius: 12,
                      defaultColor: AppColors.secondary,
                      onTap: () => context.read<UploadImageCubit>().pickImage(
                          "${userCreationReq.nama}_${userCreationReq.nisn}"),
                      child: SizedBox(
                        width: height * 0.3,
                        height: height * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: height * 0.1,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Ambil gambar",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is UploadImageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is UploadImageSuccess) {
                    return Column(
                      children: [
                        Container(
                          width: height * 0.35,
                          height: height * 0.35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(state.imageFile),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: BasicButton(
                            onPressed: () => context
                                .read<UploadImageCubit>()
                                .pickImage(
                                    "${userCreationReq.nama}_${userCreationReq.nisn}"),
                            title: "Ambil Ulang",
                          ),
                        )
                      ],
                    );
                  }
                  if (state is UploadImageFailure) {
                    return Column(
                      children: [
                        CustomInkWell(
                          borderRadius: 12,
                          defaultColor: AppColors.secondary,
                          onTap: () => context.read<UploadImageCubit>().pickImage(
                              "${userCreationReq.nama}_${userCreationReq.nisn}"),
                          child: SizedBox(
                            width: height * 0.3,
                            height: height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: height * 0.1,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Ambil gambar",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Terjadi kesalahan: ${state.message}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
              Builder(
                builder: (context) {
                  return BasicButton(
                    onPressed: () {
                      final state = context.read<UploadImageCubit>().state;
                      if (state is UploadImageSuccess) {
                        userCreationReq.imageFile = state.imageFile;
                        AppNavigator.push(
                          context,
                          AckAddStudentView(userCreationReq: userCreationReq),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Tolong unggah gambar terlebih dahulu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    title: "Lanjut",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
