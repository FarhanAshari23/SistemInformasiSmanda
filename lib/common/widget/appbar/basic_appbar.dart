import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../presentation/auth/views/login_view.dart';
import '../../../presentation/profile/views/profile_student_view.dart';
import '../../bloc/button/button.cubit.dart';
import '../../bloc/button/button_state.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../../helper/string_helper.dart';
import '../dialog/basic_dialog.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';

class BasicAppbar extends StatelessWidget {
  final bool isBackViewed;
  final bool? isLogout;
  final TeacherEntity? teacher;
  final StudentEntity? student;
  const BasicAppbar({
    super.key,
    required this.isBackViewed,
    this.isLogout,
    this.student,
    this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String teacherNickname = StringHelper.getFirstRealName(teacher?.name ?? '');
    String studentNickname = StringHelper.extractName(student?.name ?? '');
    String greeting;
    int hour = now.hour;
    if (hour < 10) {
      greeting = "Pagi";
    } else if (hour < 16) {
      greeting = "Siang";
    } else if (hour < 19) {
      greeting = "Sore";
    } else {
      greeting = "Malam";
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            AppNavigator.pushReplacement(context, LoginView());
          }
          if (state is ButtonFailureState) {
            var snackbar = SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: height * 0.09,
                color: AppColors.secondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isBackViewed
                          ? CustomInkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: 8,
                              defaultColor: AppColors.tertiary,
                              child: SizedBox(
                                width: width * 0.125,
                                height: height * 0.06,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.inversePrimary,
                                    size: 32,
                                  ),
                                ),
                              ),
                            )
                          : teacher != null
                              ? Text(
                                  'Selamat $greeting $teacherNickname!',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.inversePrimary,
                                  ),
                                )
                              : const SizedBox(),
                      student != null
                          ? Row(
                              children: [
                                Text(
                                  '$greeting $studentNickname!',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.inversePrimary,
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                GestureDetector(
                                  onTap: () => AppNavigator.push(
                                    context,
                                    ProfileStudentView(
                                      studentId: student?.id ?? 0,
                                    ),
                                  ),
                                  child: NetworkPhoto(
                                    width: width * 0.105,
                                    height: height * 0.065,
                                    shape: BoxShape.circle,
                                    fallbackAsset: student?.gender == 1
                                        ? AppImages.boyStudent
                                        : AppImages.girlStudent,
                                    imageUrl: DisplayImage.displayImageStudent(
                                        student?.name ?? '',
                                        student?.nisn ?? ''),
                                  ),
                                ),
                              ],
                            )
                          : isLogout ?? false
                              ? Builder(builder: (outerContext) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BasicDialog(
                                            buttonTitle: 'Keluar',
                                            mainTitle:
                                                'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                                            splashImage: AppImages.splashLogout,
                                            onPressed: () {
                                              outerContext
                                                  .read<ButtonStateCubit>()
                                                  .execute(
                                                    usecase: LogoutUsecase(),
                                                  );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: width * 0.125,
                                      height: height * 0.06,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.tertiary,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.logout,
                                          color: AppColors.inversePrimary,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: width * 0.4,
                child: Image.asset(
                  AppImages.logoSMA,
                  width: width * 0.2,
                  height: height * 0.095,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
