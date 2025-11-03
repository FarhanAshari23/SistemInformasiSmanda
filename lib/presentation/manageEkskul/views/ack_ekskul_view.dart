import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/succes.dart';
import 'package:new_sistem_informasi_smanda/core/configs/assets/app_images.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/create_ekskul.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/views/home_view_admin.dart';
import 'package:new_sistem_informasi_smanda/common/widget/card/card_anggota_ekskul.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../auth/widgets/button_role.dart';

class AckEkskulView extends StatelessWidget {
  final EkskulEntity ekskulCreateReq;
  const AckEkskulView({
    super.key,
    required this.ekskulCreateReq,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<UserEntity> anggota = [
      ekskulCreateReq.ketua,
      ekskulCreateReq.wakilKetua,
      ekskulCreateReq.sekretaris,
      ekskulCreateReq.bendahara,
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
            if (state is ButtonSuccessState) {
              AppNavigator.push(
                context,
                const SuccesPage(
                  page: HomeViewAdmin(),
                  title: 'Data Ekskul Berhasil Ditambahkan',
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(isBackViewed: true, isProfileViewed: false),
                const Text(
                  'Apakah data yang ditambahkan sudah sesuai?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ekskulCreateReq.namaEkskul,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              CustomInkWell(
                                borderRadius: 8,
                                defaultColor: AppColors.primary,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Deskripsi:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              ekskulCreateReq.deskripsi,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: CardAnggotaEkskul(
                              pembina: ekskulCreateReq.pembina,
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
                                  murid: anggota[index],
                                  jabatan: jabatanCard[index],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: width * 0.03),
                              itemCount: anggota.length,
                            ),
                          ),
                          const Text(
                            'Anggota:',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Image.asset(
                              AppImages.emptyRegistrationChara,
                              width: 180,
                              height: 180,
                            ),
                          ),
                          const Text(
                            'Belum ada anggota, tunggu pengguna menambahkan ekskul nya sendiri secara mandiri.',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Center(
                            child: Builder(builder: (context) {
                              return ButtonRole(
                                onPressed: () {
                                  context.read<ButtonStateCubit>().execute(
                                        usecase: CreateEkskulUseCase(),
                                        params: ekskulCreateReq,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
