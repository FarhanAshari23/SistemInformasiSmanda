import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/upload_image/upload_image_cubit.dart';
import '../../bloc/upload_image/upload_image_state.dart';
import '../appbar/basic_appbar.dart';
import '../button/basic_button.dart';
import '../inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';

class ChangePhotoView extends StatelessWidget {
  final String? picture;

  const ChangePhotoView({
    super.key,
    this.picture,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => UploadImageCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                ),
                SizedBox(height: height * 0.1),
                BlocBuilder<UploadImageCubit, UploadImageState>(
                  builder: (context, state) {
                    if (state is UploadImageSuccess) {
                      return Column(
                        children: [
                          Container(
                            key: ValueKey(state.imageFile.path +
                                DateTime.now().toString()),
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
                          const SizedBox(height: 8),
                          Builder(builder: (context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48),
                              child: BasicButton(
                                onPressed: () async {
                                  context.read<UploadImageCubit>().pickImage(
                                        picture ?? '',
                                      );
                                },
                                title: "Ambil ulang",
                              ),
                            );
                          }),
                        ],
                      );
                    }
                    if (state is UploadImageEmpty ||
                        state is UploadImageInitial) {
                      return CustomInkWell(
                        borderRadius: 12,
                        defaultColor: AppColors.secondary,
                        onTap: () async {
                          await context.read<UploadImageCubit>().pickImage(
                                picture ?? '',
                              );
                        },
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
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const Spacer(),
                BlocBuilder<UploadImageCubit, UploadImageState>(
                  builder: (context, state) {
                    return BasicButton(
                      title: "Simpan",
                      buttonColor: state is UploadImageSuccess
                          ? AppColors.primary
                          : Colors.grey,
                      onPressed: () async {
                        if (state is UploadImageInitial) return;
                        if (state is UploadImageSuccess) {
                          Navigator.pop(context, state.imageFile);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
