import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/succes.dart';
import 'package:new_sistem_informasi_smanda/data/models/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/create_ekskul.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/home_view_admin.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_anggota_ekskul.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../core/configs/theme/app_colors.dart';

class AckEkskulView extends StatelessWidget {
  final EkskulModel ekskulCreateReq;
  const AckEkskulView({
    super.key,
    required this.ekskulCreateReq,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> namaCard = [
      ekskulCreateReq.namaKetua,
      ekskulCreateReq.namaWakilKetua,
      ekskulCreateReq.namaSekretaris,
      ekskulCreateReq.namaBendahara,
    ];
    List<String> jabatanCard = [
      'Ketua',
      'Wakil Ketua',
      'Sekretaris',
      'Bendahara',
    ];
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(isBackViewed: true, isProfileViewed: false),
                const Text(
                  'Apakah data yang ditambahkan\nsudah sesuai?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: height * 0.7,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CardAnggotaEkskul(
                                namaEkskul: ekskulCreateReq.namaEkskul,
                                name: ekskulCreateReq.namaPembina,
                                jabatan: 'Pembina',
                              ),
                            ),
                            SizedBox(height: height * 0.025),
                            SizedBox(
                              width: double.infinity,
                              height: height * 0.25,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return CardAnggotaEkskul(
                                    namaEkskul: ekskulCreateReq.namaEkskul,
                                    name: namaCard[index],
                                    jabatan: jabatanCard[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: width * 0.03),
                                itemCount: namaCard.length,
                              ),
                            ),
                            Text(
                              'Deskripsi Ekskul ${ekskulCreateReq.namaEkskul}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.02),
                            Container(
                              width: double.infinity,
                              height: height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.secondary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    ekskulCreateReq.deskripsi,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: AppColors.inversePrimary,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Center(
                              child: Builder(builder: (context) {
                                return BasicButton(
                                  onPressed: () {
                                    context.read<ButtonStateCubit>().execute(
                                          usecase: CreateEkskulUseCase(),
                                          params: ekskulCreateReq,
                                        );
                                    AppNavigator.push(
                                      context,
                                      const SuccesPage(
                                        page: HomeViewAdmin(),
                                        title:
                                            'Data Ekskul\nBerhasil Ditambahkan',
                                      ),
                                    );
                                  },
                                  title: 'Simpan',
                                );
                              }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
