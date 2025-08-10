import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/jadwal_display_cubit.dart';
import '../bloc/jadwal_display_state.dart';
import '../widgets/card_jadwal.dart';

class JadwalJumat extends StatelessWidget {
  const JadwalJumat({super.key});

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
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CardJadwal(
                  jam: state.jadwals[0].hariJumat[index].jam,
                  kegiatan: state.jadwals[0].hariJumat[index].kegiatan,
                  pelaksana: state.jadwals[0].hariJumat[index].pelaksana,
                  urutan: index + 1,
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: height * 0.01,
              ),
              itemCount: state.jadwals[0].hariJumat.length,
            );
          }
          return Container();
        },
      ),
    );
  }
}
