import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/ack_add_student_view.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/gender_selection_cubit.dart';
import '../../../common/widget/box_gender.dart';

class AddStudentDetailView extends StatelessWidget {
  final UserCreationReq userCreationReq;
  AddStudentDetailView({super.key, required this.userCreationReq});
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _kelasC = TextEditingController();
  final TextEditingController _nisnC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _noHPC = TextEditingController();
  final TextEditingController _alamatC = TextEditingController();
  final TextEditingController _ekskulC = TextEditingController();
  final TextEditingController _agamaC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => GenderSelectionCubit(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: height * 0.04),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    TextField(
                      controller: _namaC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'nama:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _kelasC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'kelas:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _nisnC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'NISN:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _tanggalC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Tanggal Lahir:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _noHPC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'No HP:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _agamaC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Agama:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    const Text(
                      'Masukkan Alamat:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _alamatC,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          hintText: 'Tuliskan alamat disini...'),
                    ),
                    SizedBox(height: height * 0.02),
                    const Text(
                      'Masukkan Ekstrakulikuler:',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _ekskulC,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          hintText: 'Tuliskan ekskul disini...'),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jenis Kelamin: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        BlocBuilder<GenderSelectionCubit, int>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                BoxGender(
                                  gender: 'Laki-laki',
                                  context: context,
                                  genderIndex: 1,
                                ),
                                SizedBox(width: width * 0.01),
                                BoxGender(
                                  gender: 'Perempuan',
                                  context: context,
                                  genderIndex: 2,
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                return BasicButton(
                  onPressed: () {
                    if (_namaC.text.isEmpty ||
                        _kelasC.text.isEmpty ||
                        _nisnC.text.isEmpty ||
                        _tanggalC.text.isEmpty ||
                        _noHPC.text.isEmpty ||
                        _agamaC.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Tolong isi kolom email dan password yang telah tersedia',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      userCreationReq.nama = _namaC.text;
                      userCreationReq.kelas = _kelasC.text;
                      userCreationReq.nisn = _nisnC.text;
                      userCreationReq.tanggalLahir = _tanggalC.text;
                      userCreationReq.noHP = _noHPC.text;
                      userCreationReq.address = _alamatC.text;
                      userCreationReq.ekskul = _ekskulC.text;
                      userCreationReq.isAdmin = false;
                      userCreationReq.agama = _agamaC.text;
                      userCreationReq.gender =
                          context.read<GenderSelectionCubit>().selectedIndex;
                      AppNavigator.push(
                        context,
                        AckAddStudentView(userCreationReq: userCreationReq),
                      );
                    }
                  },
                  title: 'Lanjut',
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
