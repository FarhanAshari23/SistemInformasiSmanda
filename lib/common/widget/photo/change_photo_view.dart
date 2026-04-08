import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/teacher/update_teacher.dart';
import '../../bloc/button/button.cubit.dart';
import '../../bloc/button/button_state.dart';
import '../../bloc/teacher/teacher_cubit.dart';
import '../../bloc/upload_image/upload_image_cubit.dart';
import '../../bloc/upload_image/upload_image_state.dart';
import '../appbar/basic_appbar.dart';
import '../button/basic_button.dart';
import '../inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';

class ChangePhotoView extends StatelessWidget {
  final StudentEntity? user;
  final TeacherEntity? teacher;

  const ChangePhotoView({
    super.key,
    this.user,
    this.teacher,
  });

  String? _getName() {
    if (user != null) return user!.name;
    if (teacher != null) return teacher!.name;
    return null;
  }

  String? _getId() {
    if (user != null) return user!.nisn;
    if (teacher != null) {
      String formattedDate =
          DateFormat('d MMMM yyyy').format(teacher!.birthDate!);
      return teacher!.nip != "" ? teacher!.nip : formattedDate;
    }
    return null;
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
              if (teacher != null) {
                context
                    .read<TeacherCubit>()
                    .displayTeacherById(params: teacher!.id);
              }
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
                      if (state is UploadImageEmpty ||
                          state is UploadImageInitial) {
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
                            if (teacher != null) {
                              await context.read<ButtonStateCubit>().execute(
                                    usecase: UpdateTeacherUsecase(),
                                    params: TeacherEntity(
                                      id: teacher?.id ?? 0,
                                      name: teacher?.name ?? '',
                                      nip: teacher?.nip ?? '',
                                      tasksId: teacher?.tasksId ?? [],
                                      birthDate: teacher?.birthDate ??
                                          DateTime(2000, 1, 1),
                                      gender: teacher?.gender ?? 0,
                                      imageFile: state.imageFile,
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
