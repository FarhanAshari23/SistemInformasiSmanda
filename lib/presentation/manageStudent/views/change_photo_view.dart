import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';

import '../../../common/bloc/upload_image/upload_image_cubit.dart';
import '../../../common/bloc/upload_image/upload_image_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/user.dart';

class ChangePhotoView extends StatefulWidget {
  final UserEntity user;
  const ChangePhotoView({
    super.key,
    required this.user,
  });

  @override
  State<ChangePhotoView> createState() => _ChangePhotoViewState();
}

class _ChangePhotoViewState extends State<ChangePhotoView> {
  bool imageLoaded = false;
  bool imageFailed = false;
  @override
  void initState() {
    super.initState();

    final ImageStream stream = NetworkImage(DisplayImage.displayImageStudent(
            widget.user.nama!, widget.user.nisn!))
        .resolve(const ImageConfiguration());

    stream.addListener(
      ImageStreamListener(
        (info, _) {
          setState(() {
            imageLoaded = true;
          });
        },
        onError: (error, stackTrace) {
          setState(() {
            imageFailed = true;
          });
        },
      ),
    );
  }

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
                      ],
                    );
                  }
                  if (imageFailed) {
                    return CustomInkWell(
                      borderRadius: 12,
                      defaultColor: AppColors.secondary,
                      onTap: () => context
                          .read<UploadImageCubit>()
                          .pickImage("${widget.user.nama}_${widget.user.nisn}"),
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
                  return Container(
                    width: height * 0.35,
                    height: height * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          DisplayImage.displayImageStudent(
                            widget.user.nama!,
                            widget.user.nisn!,
                          ),
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              ),
              Visibility(
                visible: imageLoaded && !imageFailed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Builder(builder: (context) {
                    return BasicButton(
                      onPressed: () => context
                          .read<UploadImageCubit>()
                          .pickImage("${widget.user.nama}_${widget.user.nisn}"),
                      title: "Perbarui",
                    );
                  }),
                ),
              ),
              const Spacer(),
              Builder(
                builder: (context) {
                  return BasicButton(
                    onPressed: () {
                      final imageProfile =
                          context.read<UploadImageCubit>().state;
                      if (imageProfile is UploadImageSuccess) {
                        Navigator.pop(context, imageProfile.imageFile);
                      }
                    },
                    title: "Simpan",
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
