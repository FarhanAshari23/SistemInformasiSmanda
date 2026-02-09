import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/succes.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/auth/signup.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/widgets/button_role.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/widgets/card_ack.dart';

import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import 'login_view.dart';

class AckAddStudentView extends StatelessWidget {
  final UserCreationReq userCreationReq;
  const AckAddStudentView({
    super.key,
    required this.userCreationReq,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> titleList = [
      'Nama',
      'Kelas',
      'NISN',
      'Tanggal Lahir',
      'No HP',
      'Alamat',
      'Gender',
      'Agama',
    ];
    List<dynamic> contentList = [
      userCreationReq.nama,
      userCreationReq.kelas,
      userCreationReq.nisn,
      userCreationReq.tanggalLahir,
      userCreationReq.noHP,
      userCreationReq.address,
      userCreationReq.gender == 1 ? 'Laki-Laki' : 'Perempuan',
      userCreationReq.agama,
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccesPage(
                    page: LoginView(),
                    title:
                        "Akun berhasil dibuat. Tunggu admin menyetujui akun anda untuk bisa digunakan dan jangan lupa update ekskul anda di halaman profile",
                  ),
                ),
                (route) => route.isFirst,
              );
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const BasicAppbar(
                    isBackViewed: true,
                    isProfileViewed: false,
                  ),
                  const Text(
                    'TAMBAH DATA SISWA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  const Text(
                    'Apakah data sudah sesuai?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.4,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        if (index == titleList.length &&
                            userCreationReq.imageFile != null) {
                          return CardAck(
                            title: "Foto",
                            image: userCreationReq.imageFile,
                          );
                        } else {
                          return CardAck(
                            title: titleList[index],
                            content: contentList[index],
                          );
                        }
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.01),
                      itemCount: userCreationReq.imageFile != null
                          ? titleList.length + 1
                          : titleList.length,
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  Builder(
                    builder: (context) {
                      return ButtonRole(
                        onPressed: () {
                          context.read<ButtonStateCubit>().execute(
                                usecase: SignUpUseCase(),
                                params: userCreationReq,
                              );
                        },
                        title: 'Simpan',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
