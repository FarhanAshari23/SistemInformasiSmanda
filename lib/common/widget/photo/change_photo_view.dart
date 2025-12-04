import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';

import '../../bloc/upload_image/upload_image_cubit.dart';
import '../../bloc/upload_image/upload_image_state.dart';
import '../../helper/cache_manager.dart';
import '../appbar/basic_appbar.dart';
import '../button/basic_button.dart';
import '../inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/auth/user.dart';

class ChangePhotoView extends StatefulWidget {
  final UserEntity? user;
  final TeacherEntity? teacher;

  const ChangePhotoView({
    super.key,
    this.user,
    this.teacher,
  });

  @override
  State<ChangePhotoView> createState() => _ChangePhotoViewState();
}

class _ChangePhotoViewState extends State<ChangePhotoView> {
  bool imageLoaded = false;
  bool imageFailed = false;

  String? _getName() {
    if (widget.user != null) return widget.user!.nama;
    if (widget.teacher != null) return widget.teacher!.nama;
    return null;
  }

  String? _getId() {
    if (widget.user != null) return widget.user!.nisn;
    if (widget.teacher != null) {
      return widget.teacher!.nip != ""
          ? widget.teacher!.nip
          : widget.teacher!.tanggalLahir.toString();
    }
    return null;
  }

  String? _getImageUrl() {
    final name = _getName();
    final id = _getId();
    if (name == null || id == null) return null;

    return widget.user != null
        ? DisplayImage.displayImageStudent(name, id)
        : DisplayImage.displayImageTeacher(name, id);
  }

  @override
  void initState() {
    super.initState();

    final url = _getImageUrl();
    if (url == null || url.isEmpty) {
      imageFailed = true;
      return;
    }

    final provider = CachedNetworkImageProvider(
      url,
      cacheManager: FastCacheManager(),
    );

    final stream = provider.resolve(const ImageConfiguration());

    stream.addListener(
      ImageStreamListener(
        (info, _) {
          if (mounted) {
            setState(() {
              imageLoaded = true;
            });
          }
        },
        onError: (error, stackTrace) {
          if (mounted) {
            setState(() {
              imageFailed = true;
            });
          }
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
                        const SizedBox(height: 8),
                        Visibility(
                          visible: !imageLoaded && imageFailed,
                          child: Builder(builder: (context) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48),
                              child: BasicButton(
                                onPressed: () =>
                                    context.read<UploadImageCubit>().pickImage(
                                          "${_getName()}_${_getId()}",
                                        ),
                                title: "Ambil ulang",
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  }
                  if (imageFailed) {
                    return CustomInkWell(
                      borderRadius: 12,
                      defaultColor: AppColors.secondary,
                      onTap: () => context.read<UploadImageCubit>().pickImage(
                            "${_getName()}_${_getId()}",
                          ),
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
                  return Container(
                    width: height * 0.35,
                    height: height * 0.35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(_getImageUrl()!),
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
                      onPressed: () =>
                          context.read<UploadImageCubit>().pickImage(
                                "${_getName()}_${_getId()}",
                              ),
                      title: "Ambil ulang",
                    );
                  }),
                ),
              ),
              const Spacer(),
              Builder(
                builder: (context) {
                  return BasicButton(
                    onPressed: () {
                      final state = context.read<UploadImageCubit>().state;
                      if (state is UploadImageSuccess) {
                        Navigator.pop(context, state.imageFile);
                      }
                    },
                    title: "Simpan",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
