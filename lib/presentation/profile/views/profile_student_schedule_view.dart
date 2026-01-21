import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/core/constants/notes.dart';

import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/jadwal_display_cubit.dart';
import '../bloc/jadwal_display_state.dart';
import '../widgets/card_jadwal.dart';

class ProfileStudentScheduleView extends StatelessWidget {
  final String hari;
  const ProfileStudentScheduleView({
    super.key,
    required this.hari,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<JadwalDisplayCubit, JadwalDisplayState>(
      builder: (context, state) {
        if (state is JadwalDisplayLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is JadwalDisplayLoaded) {
          if (state.jadwals.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: height * 0.15),
              child: const Center(child: Text('Tidak ada jadwal')),
            );
          }

          final jadwal = state.jadwals[0];
          final listKegiatan = jadwal.hari[hari] ?? [];
          if (listKegiatan.isEmpty) {
            return const Center(
                child: Text('Pada hari ini, tidak ada kegiatan'));
          }
          return ListView.separated(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemBuilder: (context, index) {
              if (hari == "Jumat" && index == 0) {
                return Padding(
                  padding: EdgeInsets.only(left: width * 0.85),
                  child: CustomInkWell(
                    borderRadius: 8,
                    defaultColor: AppColors.primary,
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            alignment: Alignment.center,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Catatan:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    Notes.noteFridayStudents,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  BasicButton(
                                    onPressed: () => Navigator.pop(context),
                                    title: "Saya Mengerti",
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }
              final item = listKegiatan[hari == "Jumat" ? index - 1 : index];
              return CardJadwal(
                jam: item.jam,
                kegiatan: item.kegiatan,
                pelaksana: item.pelaksana,
                urutan: index + (hari == "Jumat" ? 0 : 1),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: height * 0.01,
            ),
            itemCount:
                hari == "Jumat" ? listKegiatan.length + 1 : listKegiatan.length,
          );
        }
        if (state is JadwalDisplayFailure) {
          return Container();
        }
        return Container();
      },
    );
  }
}
