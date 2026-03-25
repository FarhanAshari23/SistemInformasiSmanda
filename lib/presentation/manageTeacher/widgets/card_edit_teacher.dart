import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/detail/teacher_detail.dart';
import '../../../common/widget/dialog/basic_dialog.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/teacher/delete_teacher.dart';
import '../../../service_locator.dart';
import '../views/edit_teacher_detail_view.dart';

class CardEditTeacher extends StatelessWidget {
  final TeacherEntity teacher;
  const CardEditTeacher({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    String formattedDate = DateFormat('d MMMM yyyy').format(teacher.birthDate!);
    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: () {
        AppNavigator.push(
          context,
          TeacherDetail(
            teacherId: teacher.id ?? 0,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkPhoto(
                  height: mediaQueryHeight * 0.14,
                  width: width * 0.235,
                  fallbackAsset: teacher.gender == 1
                      ? AppImages.guruLaki
                      : AppImages.guruPerempuan,
                  imageUrl: DisplayImage.displayImageTeacher(
                    teacher.name ?? '',
                    teacher.nip != '-' ? teacher.nip! : formattedDate,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 16.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '${teacher.name}\n',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                        children: [
                          WidgetSpan(
                            child: SizedBox(
                              height: bodyHeight * 0.03,
                            ),
                          ),
                          TextSpan(
                            text: teacher.nip ?? "-",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: PopupMenuButton(
              onSelected: (String value) {
                if (value == 'Edit') {
                  AppNavigator.push(
                    context,
                    BlocProvider.value(
                      value: context.read<TeacherCubit>(),
                      child: EditTeacherDetailView(teacher: teacher),
                    ),
                  );
                } else if (value == 'Hapus') {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return BasicDialog(
                        splashImage: AppImages.splashDelete,
                        mainTitle:
                            'Apakah anda yakin ingin menghapus data ${teacher.name}?',
                        buttonTitle: 'Hapus',
                        onPressed: () async {
                          var delete = await sl<DeleteTeacherUsecase>()
                              .call(params: teacher.id);
                          return delete.fold(
                            (error) {
                              var snackbar = SnackBar(
                                content: Text(
                                    "Gagal Menghapus Data Guru: ${error.toString()}"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            (r) {
                              var snackbar = const SnackBar(
                                content: Text("Data Berhasil Dihapus"),
                              );
                              context.read<TeacherCubit>().displayTeacher();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Hapus',
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.inversePrimary,
                      ),
                    ),
                  ),
                ];
              },
              child: Container(
                width: width * 0.1,
                height: bodyHeight * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
