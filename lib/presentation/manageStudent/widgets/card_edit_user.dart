import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/helper/display_image.dart';
import '../../../common/widget/detail/murid_detail.dart';
import '../../../common/widget/dialog/basic_dialog.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/usecases/students/delete_student.dart';
import '../../../service_locator.dart';
import '../views/edit_student_detail.dart';

class CardEditUser extends StatelessWidget {
  final StudentEntity student;
  const CardEditUser({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;

    return CustomInkWell(
      borderRadius: 12,
      defaultColor: AppColors.secondary,
      onTap: () {
        AppNavigator.push(
          context,
          MuridDetail(
            userId: student.id ?? 0,
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: NetworkPhoto(
                    height: mediaQueryHeight * 0.15,
                    width: width * 0.235,
                    fallbackAsset: student.gender == 1
                        ? AppImages.boyStudent
                        : student.religion == "Islam"
                            ? AppImages.girlStudent
                            : AppImages.girlNonStudent,
                    imageUrl: DisplayImage.displayImageStudent(
                      student.name ?? '',
                      student.nisn ?? '',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 16.0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: '${student.name}\n',
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
                            text: student.nisn!,
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
                        value: context.read<StudentsDisplayCubit>(),
                        child: EditStudentDetail(user: student),
                      ));
                } else if (value == 'Hapus') {
                  final outerContext = context;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BasicDialog(
                        splashImage: AppImages.splashDelete,
                        mainTitle:
                            "Apakah anda yakin ingin menghapus data ${student.name}",
                        buttonTitle: "Hapus",
                        onPressed: () async {
                          var delete = await sl<DeleteStudentUsecase>()
                              .call(params: student.gender);
                          return delete.fold(
                            (error) {
                              var snackbar = const SnackBar(
                                content:
                                    Text("Gagal Menghapus Murid, Coba Lagi"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            (r) {
                              Navigator.pop(context);
                              var snackbar = const SnackBar(
                                content: Text("Data Berhasil Dihapus"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              outerContext
                                  .read<StudentsDisplayCubit>()
                                  .displayStudents();
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
