import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/create_teacher.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../auth/widgets/button_role.dart';
import '../../home/views/home_view_admin.dart';
import '../../manageStudent/widgets/card_ack.dart';

class AckAddTeacherView extends StatelessWidget {
  final TeacherEntity teacherCreationReq;
  const AckAddTeacherView({
    super.key,
    required this.teacherCreationReq,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> titleList = [
      'Nama',
      'Email',
      "NIP",
      "Mengajar",
      "Tanggal Lahir",
      "Wali Kelas",
      'Jabatan',
      "Gender",
    ];
    List<String> contentList = [
      teacherCreationReq.nama,
      teacherCreationReq.email ?? '',
      teacherCreationReq.nip,
      teacherCreationReq.mengajar,
      teacherCreationReq.tanggalLahir,
      teacherCreationReq.waliKelas,
      teacherCreationReq.jabatan,
      teacherCreationReq.gender == 1 ? 'Laki-Laki' : 'Perempuan',
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
                  title: "Data Guru Berhasil Ditambahkan",
                ),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const Text(
                  'TAMBAH DATA GURU',
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      if (index == titleList.length) {
                        return CardAck(
                          title: titleList[index],
                          content: contentList[index],
                          image: teacherCreationReq.image,
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
                    itemCount: titleList.length - 1,
                  ),
                ),
                SizedBox(height: height * 0.06),
                Builder(
                  builder: (context) {
                    return ButtonRole(
                      onPressed: () {
                        context.read<ButtonStateCubit>().execute(
                              usecase: CreateTeacherUseCase(),
                              params: teacherCreationReq,
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
    );
  }
}
