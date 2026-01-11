import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/dialog/basic_dialog.dart';
import 'package:stacked_listview/stacked_listview.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/schedule/delete_jadwal_usecase.dart';
import '../bloc/get_all_jadwal_cubit.dart';
import '../bloc/get_all_jadwal_state.dart';
import 'edit_schedule_detail.dart';

class EditScheduleView extends StatelessWidget {
  const EditScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GetAllJadwalCubit()..displayAllJadwal(),
            ),
            BlocProvider(
              create: (context) => ButtonStateCubit(),
            ),
          ],
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ButtonSuccessState) {
                context.read<GetAllJadwalCubit>().displayAllJadwal();
                Navigator.of(context, rootNavigator: true).pop();
                var snackbar = const SnackBar(
                  content: Text("Data Berhasil Dihapus"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
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
                                                child: EditScheduleDetailView(
                                                  kelas: schedule.kelas,
                                                  schedule: schedule,
                                                ),
                                              ));
                                        } else if (value == 'Hapus') {
                                          final outerContext = context;
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return BasicDialog(
                                                width: width,
                                                height: height,
                                                splashImage:
                                                    AppImages.splashDelete,
                                                mainTitle:
                                                    'Apakah anda yakin ingin menghapus jadwal ${schedule.kelas}?',
                                                buttonTitle: 'Hapus',
                                                onPressed: () {
                                                  outerContext
                                                      .read<ButtonStateCubit>()
                                                      .execute(
                                                        usecase:
                                                            DeleteJadwalUsecase(),
                                                        params: schedule.kelas,
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
      ),
    );
  }
}
