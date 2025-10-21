import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacked_listview/stacked_listview.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/schedule/delete_jadwal_usecase.dart';
import '../../../service_locator.dart';
import '../bloc/get_all_jadwal_cubit.dart';
import '../bloc/get_all_jadwal_state.dart';
import '../widgets/edit_schedule_detail.dart';

class EditScheduleView extends StatelessWidget {
  const EditScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => GetAllJadwalCubit()..displayAllJadwal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  'Silakan pilih kelas:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              BlocBuilder<GetAllJadwalCubit, GetAllJadwalState>(
                builder: (context, state) {
                  if (state is GetAllJadwalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GetAllJadwalLoaded) {
                    return Expanded(
                      child: StackedListView(
                        itemExtent: width * 0.55,
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: height * 0.2,
                          left: 16,
                          right: 16,
                        ),
                        scrollDirection: Axis.horizontal,
                        builder: (context, index) {
                          final schedule = state.jadwals[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Kelas\n',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: schedule.kelas,
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: PopupMenuButton(
                                    onSelected: (String value) {
                                      if (value == 'Edit') {
                                        AppNavigator.push(
                                            context,
                                            BlocProvider.value(
                                              value: context
                                                  .read<GetAllJadwalCubit>(),
                                              child: EditScheduleDetail(
                                                kelas: schedule.kelas,
                                                schedule: schedule,
                                              ),
                                            ));
                                      } else if (value == 'Hapus') {
                                        final outerContext = context;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor:
                                                  AppColors.inversePrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SizedBox(
                                                width: width * 0.7,
                                                height: height * 0.55,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: width * 0.6,
                                                      height: height * 0.3,
                                                      decoration:
                                                          const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              AppImages
                                                                  .splashDelete),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'Apakah anda yakin ingin menghapus jadwal ${schedule.kelas}?',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    BasicButton(
                                                      onPressed: () async {
                                                        var delete = await sl<
                                                                DeleteJadwalUsecase>()
                                                            .call(
                                                                params: schedule
                                                                    .kelas);
                                                        delete.fold(
                                                          (error) {
                                                            var snackbar =
                                                                const SnackBar(
                                                              content: Text(
                                                                  "Gagal Menghapus Jadwal, Coba Lagi"),
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackbar);
                                                          },
                                                          (r) {
                                                            outerContext
                                                                .read<
                                                                    GetAllJadwalCubit>()
                                                                .displayAllJadwal();
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                            var snackbar =
                                                                const SnackBar(
                                                              content: Text(
                                                                  "Data Berhasil Dihapus"),
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackbar);
                                                          },
                                                        );
                                                      },
                                                      title: 'Hapus',
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                                      height: height * 0.05,
                                      color: AppColors.primary,
                                      child: const Center(
                                        child: Icon(
                                          Icons.more_vert_rounded,
                                          color: AppColors.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: state.jadwals.length,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
