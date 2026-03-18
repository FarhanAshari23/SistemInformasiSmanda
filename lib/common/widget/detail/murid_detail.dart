import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/student/get_student_cubit.dart';
import '../../bloc/student/get_student_state.dart';
import '../../helper/display_image.dart';
import '../photo/network_photo.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/students/widgets/card_detail.dart';

class MuridDetail extends StatelessWidget {
  final int userId;
  const MuridDetail({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pagecontroller = PageController();
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyHeight = mediaQueryHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;

    Event buildEvent(String tanggal, nama) {
      DateFormat format = DateFormat("d MMMM yyyy", "id_ID");
      DateTime parsedDate = format.parse(tanggal);
      int currentYear = DateTime.now().year;
      DateTime finalDate =
          DateTime(currentYear, parsedDate.month, parsedDate.day);
      return Event(
        title: 'Ulang tahun $nama',
        description: 'Mari rayakan ulang tahun teman kamu!',
        location: 'SMA N 2 METRO',
        startDate: finalDate,
        endDate: finalDate.add(const Duration(hours: 23)),
        allDay: false,
      );
    }

    Future<void> openMapWithAddress(String address) async {
      final Uri uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
      );

      try {
        final bool launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);

        if (!launched) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } catch (e) {
        debugPrint("Gagal membuka Maps: $e");
      }
    }

    Future<void> openAddContact(String phone) async {
      final Uri uri = Uri(
        scheme: 'tel',
        path: phone,
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    return BlocProvider(
      create: (context) => StudentCubit()..displayStudentById(params: userId),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: bodyHeight,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: bodyHeight * 0.51,
                              child: Stack(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: width,
                                      height: double.infinity,
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
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                ],
                              ),
                            ),
                            Positioned(
                              top: bodyHeight * 0.45,
                              child: Container(
                                width: width,
                                height: bodyHeight * 0.6,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: AppColors.inversePrimary,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 32),
                                  child: Center(
                                    child: Text(
                                      "Sedang memuat..",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                      ),
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
              if (state is StudentLoaded) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: bodyHeight,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: bodyHeight * 0.51,
                              child: Stack(
                                children: [
                                  NetworkPhoto(
                                    width: double.infinity,
                                    height: bodyHeight,
                                    fallbackAsset: state.student.gender == 1
                                        ? AppImages.boyStudent
                                        : state.student.religion == "Islam"
                                            ? AppImages.girlStudent
                                            : AppImages.girlNonStudent,
                                    imageUrl: DisplayImage.displayImageStudent(
                                      state.student.name ?? '',
                                      state.student.nisn ?? '',
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
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                ],
                              ),
                            ),
                            Positioned(
                              top: bodyHeight * 0.45,
                              child: Container(
                                width: width,
                                height: bodyHeight * 0.6,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  color: AppColors.inversePrimary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 32),
                                  child: Column(
                                    children: [
                                      Text(
                                        state.student.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        state.student.nameClass ?? '',
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
                                                    title: 'Tanggal Lahir',
                                                    onTap: () => Add2Calendar
                                                        .addEvent2Cal(buildEvent(
                                                            state.student.name!,
                                                            state.student
                                                                .birthDate
                                                                .toString())),
                                                    content: state
                                                        .student.birthDate
                                                        .toString(),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: CardDetailSiswa(
                                                    title: 'Alamat',
                                                    content:
                                                        state.student.address!,
                                                    onTap: () =>
                                                        openMapWithAddress(state
                                                            .student.address!),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: CardDetailSiswa(
                                                      title: 'Agama',
                                                      content: state
                                                          .student.religion!,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: CardDetailSiswa(
                                                      title: 'Jenis Kelamin',
                                                      content: state.student
                                                                  .gender! ==
                                                              1
                                                          ? 'Laki-laki'
                                                          : 'Perempuan',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: CardDetailSiswa(
                                                      title: 'No HP',
                                                      content: state
                                                          .student.mobileNum!,
                                                      onTap: () =>
                                                          openAddContact(state
                                                              .student
                                                              .mobileNum!),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Expanded(
                                                    child: CardDetailSiswa(
                                                      title: 'Ekskul',
                                                      content:
                                                          "Belum diisi ekskul",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: bodyHeight * 0.03),
                                      SmoothPageIndicator(
                                        controller: pagecontroller,
                                        count: 3,
                                        effect: const ExpandingDotsEffect(
                                          activeDotColor: AppColors.primary,
                                          dotColor: AppColors.secondary,
                                        ),
                                      )
                                    ],
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

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
