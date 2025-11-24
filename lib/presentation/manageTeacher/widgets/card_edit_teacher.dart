import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/teacher/teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/dialog/basic_dialog.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
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
    return Container(
      width: width * 0.7,
      height: bodyHeight * 0.175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                NetworkPhoto(
                  width: width * 0.25,
                  height: bodyHeight * 0.12,
                  fallbackAsset: teacher.gender == 1
                      ? AppImages.guruLaki
                      : AppImages.guruPerempuan,
                  imageUrl: DisplayImage.displayImageTeacher(
                    teacher.nama,
                    teacher.nip != '-' ? teacher.nip : teacher.tanggalLahir,
                  ),
                ),
                SizedBox(width: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.465,
                        height: bodyHeight * 0.06,
                        child: Text(
                          teacher.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.4,
                        height: bodyHeight * 0.04,
                        child: Text(
                          teacher.nip,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    ],
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
                        width: width,
                        height: bodyHeight,
                        splashImage: AppImages.splashDelete,
                        mainTitle:
                            'Apakah anda yakin ingin menghapus data ${teacher.nama}?',
                        buttonTitle: 'Hapus',
                        onPressed: () async {
                          var delete = await sl<DeleteTeacherUsecase>()
                              .call(params: teacher);
                          return delete.fold(
                            (error) {
                              var snackbar = const SnackBar(
                                content: Text(
                                    "Gagal Menghapus Data Guru, Coba Lagi"),
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
