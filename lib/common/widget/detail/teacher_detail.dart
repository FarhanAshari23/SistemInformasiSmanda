import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/widget/schedule/teacher_schedule_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../bloc/teacher/teacher_cubit.dart';
import '../../bloc/teacher/teacher_state.dart';
import '../../helper/app_navigation.dart';
import '../../helper/display_image.dart';
import '../inkwell/custom_inkwell.dart';
import '../photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/students/widgets/card_detail.dart';

class TeacherDetail extends StatelessWidget {
  final int teacherId;
  const TeacherDetail({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pagecontroller = PageController();
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) =>
          TeacherCubit()..displayTeacherById(params: teacherId),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<TeacherCubit, TeacherState>(
            builder: (context, state) {
              if (state is TeacherLoading) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: bodyHeight,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: width,
                                height: bodyHeight * 0.51,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primary,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: AppColors.inversePrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 24,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: AppColors.inversePrimary,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Sedang memuat",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is TeacherLoaded) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: bodyHeight,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            NetworkPhoto(
                              width: double.infinity,
                              height: bodyHeight * 0.51,
                              fallbackAsset: state.teacher.gender == 1
                                  ? AppImages.guruLaki
                                  : AppImages.guruPerempuan,
                              imageUrl: DisplayImage.displayImageTeacher(
                                state.teacher.name!,
                                state.teacher.nip != null
                                    ? state.teacher.nip!
                                    : DateFormat('d MMMM yyyy', "id_ID")
                                        .format(state.teacher.birthDate!),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primary,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: AppColors.inversePrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 24,
                                ),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: AppColors.inversePrimary,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      state.teacher.name ?? '',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      state.teacher.nip ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: bodyHeight * 0.02),
                                    SizedBox(
                                      width: double.infinity,
                                      height: bodyHeight * 0.3,
                                      child: PageView(
                                        controller: pagecontroller,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: CardDetailSiswa(
                                                  title: 'Wali Kelas',
                                                  content:
                                                      state.teacher.waliKelas ??
                                                          '',
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: CardDetailSiswa(
                                                  title: 'Tugas tambahan',
                                                  content: state.teacher
                                                              .tasksName !=
                                                          null
                                                      ? state.teacher.tasksName!
                                                          .join(",")
                                                      : "-",
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4),
                                                  child: CardDetailSiswa(
                                                    title: 'Tanggal Lahir',
                                                    content: DateFormat(
                                                            'd MMMM yyyy',
                                                            "id_ID")
                                                        .format(state.teacher
                                                            .birthDate!),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 16,
                                                    top: 16,
                                                  ),
                                                  child: CustomInkWell(
                                                    borderRadius: 8,
                                                    defaultColor:
                                                        AppColors.secondary,
                                                    onTap: () =>
                                                        AppNavigator.push(
                                                      context,
                                                      TeacherScheduleDetail(
                                                        teacherId: teacherId,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: bodyHeight *
                                                                0.1,
                                                          ),
                                                          child: Text(
                                                            "Lihat Jadwal\nGuru",
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .inversePrimary,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              8),
                                                                    ),
                                                                    color: AppColors
                                                                        .primary),
                                                            child: const Icon(
                                                              Icons
                                                                  .arrow_right_alt_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: bodyHeight * 0.03),
                                    SmoothPageIndicator(
                                      controller: pagecontroller,
                                      count: 2,
                                      effect: const ExpandingDotsEffect(
                                        activeDotColor: AppColors.primary,
                                        dotColor: AppColors.secondary,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is TeacherFailure) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
