import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/delete_ekskul.dart';

import '../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../service_locator.dart';
import '../views/edit_ekskul_detail.dart';

class CardEkskulEdit extends StatelessWidget {
  final EkskulEntity ekskul;
  const CardEkskulEdit({
    super.key,
    required this.ekskul,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondary,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.19,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.splashEkskul),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ekskul.namaEkskul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.inversePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: -(height * 0.0085),
            right: -(width * 0.0165),
            child: PopupMenuButton(
              onSelected: (String value) {
                if (value == 'Edit') {
                  final ekskulCubit = context.read<EkskulCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: ekskulCubit, // pastikan ambil cubit dari parent
                        child: EditEkskulDetail(ekskul: ekskul),
                      ),
                    ),
                  );
                } else if (value == 'Hapus') {
                  final outerContext = context;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: AppColors.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: width * 0.7,
                          height: height * 0.55,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.6,
                                height: height * 0.3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImages.splashDelete),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'Apakah anda yakin ingin menghapus data ${ekskul.namaEkskul}?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: height * 0.02),
                              Builder(builder: (context) {
                                return BasicButton(
                                  onPressed: () async {
                                    var delete = await sl<DeleteEkskulUsecase>()
                                        .call(params: ekskul);
                                    return delete.fold(
                                      (error) {
                                        var snackbar = const SnackBar(
                                          content: Text(
                                              "Gagal Menghapus Ekskul, Coba Lagi"),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                      },
                                      (r) {
                                        var snackbar = const SnackBar(
                                          content:
                                              Text("Data Berhasil Dihapus"),
                                        );
                                        outerContext
                                            .read<EkskulCubit>()
                                            .displayEkskul();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackbar);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                  title: 'Hapus',
                                );
                              }),
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
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.inversePrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
