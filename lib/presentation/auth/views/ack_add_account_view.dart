import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/landing/succes.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/auth/signup.dart';
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
      'Ekskul',
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
      userCreationReq.ekskul,
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
                      itemBuilder: (context, index) {
                        return CardAck(
                          title: titleList[index],
                          content: contentList[index],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: width * 0.01),
                      itemCount: titleList.length,
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  Builder(
                    builder: (context) {
                      return BasicButton(
                        onPressed: () {
                          context.read<ButtonStateCubit>().execute(
                                usecase: SignUpUseCase(),
                                params: userCreationReq,
                              );
                          AppNavigator.push(
                            context,
                            SuccesPage(
                              page: LoginView(),
                              title: "Akun berhasil dibuat",
                            ),
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
