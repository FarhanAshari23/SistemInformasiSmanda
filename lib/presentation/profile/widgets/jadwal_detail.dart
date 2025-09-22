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
        if (state is JadwalDisplayFailure) {
          return Container();
        }
        return Container();
      },
    );
  }
}
