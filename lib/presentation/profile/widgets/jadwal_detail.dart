import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/jadwal_display_cubit.dart';
import '../bloc/jadwal_display_state.dart';
import 'card_jadwal.dart';

class JadwalDetail extends StatelessWidget {
  final String hari;
  const JadwalDetail({
    super.key,
    required this.hari,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => JadwalDisplayCubit()..displayJadwal(),
      child: BlocBuilder<JadwalDisplayCubit, JadwalDisplayState>(
        builder: (context, state) {
          if (state is JadwalDisplayLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is JadwalDisplayLoaded) {
            final jadwal = state.jadwals[0];
            final listKegiatan = jadwal.hari[hari] ?? [];
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final item = listKegiatan[index];
                return CardJadwal(
                  jam: item.jam,
                  kegiatan: item.kegiatan,
                  pelaksana: item.pelaksana,
                  urutan: index + 1,
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: height * 0.01,
              ),
              itemCount: listKegiatan.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
