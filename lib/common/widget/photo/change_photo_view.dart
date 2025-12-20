import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/update_teacher.dart';

import '../../../presentation/profile/bloc/profile_info_cubit.dart';
import '../../bloc/button/button.cubit.dart';
import '../../bloc/button/button_state.dart';
import '../../bloc/upload_image/upload_image_cubit.dart';
import '../../bloc/upload_image/upload_image_state.dart';
import '../appbar/basic_appbar.dart';
import '../button/basic_button.dart';
import '../inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/auth/user.dart';

class ChangePhotoView extends StatelessWidget {
  final UserEntity? user;
  final TeacherEntity? teacher;
  final bool isProfileTeacher;

  const ChangePhotoView({
    super.key,
    this.user,
    this.teacher,
    this.isProfileTeacher = false,
  });

  String? _getName() {
    if (user != null) return user!.nama;
    if (teacher != null) return teacher!.nama;
    return null;
  }

  String? _getId() {
    if (user != null) return user!.nisn;
    if (teacher != null) {
      return teacher!.nip != ""
          ? teacher!.nip
          : teacher!.tanggalLahir.toString();
    }
    return null;
  }

  String? _getImageUrl() {
    final name = _getName();
    final id = _getId();
    if (name == null || id == null) return null;

    return user != null
        ? DisplayImage.displayImageStudent(name, id)
        : DisplayImage.displayImageTeacher(name, id);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UploadImageCubit(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<UploadImageCubit>().loadInitialImage(_getImageUrl());
        });
        return BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              context.read<ProfileInfoCubit>().getUser("Teachers");

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Berhasil mengubah foto")),
              );

              Navigator.pop(context);
            }
          },
          child: Scaffold(
            body: SafeArea(
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
                                          "${_getName()}_${_getId()}",
                                        );
                                  },
                                  title: "Ambil ulang",
                                ),
                              );
                            }),
                          ],
                        );
                      }
                      if (state is UploadImageNetwork) {
                        return Column(
                          children: [
                            Container(
                              key: ValueKey(
                                  state.imageUrl + DateTime.now().toString()),
                              width: height * 0.35,
                              height: height * 0.35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(state.imageUrl),
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
                                          "${_getName()}_${_getId()}",
                                        );
                                  },
                                  title: "Ganti Foto",
                                ),
                              );
                            }),
                          ],
                        );
                      }
                      return CustomInkWell(
                        borderRadius: 12,
                        defaultColor: AppColors.secondary,
                        onTap: () async {
                          await context.read<UploadImageCubit>().pickImage(
                                "${_getName()}_${_getId()}",
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
                    },
                  ),
                  const Spacer(),
                  BlocBuilder<UploadImageCubit, UploadImageState>(
                    builder: (context, state) {
                      return BasicButton(
                        title: "Simpan",
                        buttonColor: state is UploadImageSuccess ||
                                state is UploadImageNetwork
                            ? AppColors.primary
                            : Colors.grey,
                        onPressed: () async {
                          if (state is UploadImageInitial) return;
                          if (state is UploadImageSuccess) {
                            if (isProfileTeacher) {
                              await context.read<ButtonStateCubit>().execute(
                                    usecase: UpdateTeacherUsecase(),
                                    params: TeacherEntity(
                                      nama: teacher!.nama,
                                      mengajar: teacher!.mengajar,
                                      nip: teacher!.nip,
                                      tanggalLahir: teacher!.tanggalLahir,
                                      waliKelas: teacher!.waliKelas,
                                      jabatan: teacher!.jabatan,
                                      gender: teacher!.gender,
                                      image: state.imageFile,
                                    ),
                                  );
                            } else {
                              Navigator.pop(context, state.imageFile);
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
