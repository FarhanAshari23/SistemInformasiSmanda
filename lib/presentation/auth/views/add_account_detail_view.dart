import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/bloc/religion_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/ack_add_account_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/widgets/scan_qr_nisn.dart';

import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/gender_selection_cubit.dart';
import '../../../common/widget/card/box_gender.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GenderSelectionCubit(),
          ),
          BlocProvider(
            create: (context) => ReligionCubit(),
          ),
        ],
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Text(
                'Isi detail akun',
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
                      decoration: InputDecoration(
                        hintText: 'NISN:',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final result = await showDialog(
                              useSafeArea: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Scan QR NISN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          "Arahkan kamera ke barcode kartu siswamu."),
                                      SizedBox(height: height * 0.01),
                                      SizedBox(
                                        width: width * 0.9,
                                        height: height * 0.25,
                                        child: ScanQrNisn(),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                      },
                                      child: const Text("Tutup"),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result != null && result.isNotEmpty) {
                              _nisnC.text = result;
                            }
                          },
                          icon: const Icon(Icons.qr_code_2),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      controller: _tanggalC,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          locale: const Locale('id', 'ID'),
                          confirmText: "Oke",
                          cancelText: "Keluar",
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: AppColors
                                      .inversePrimary, // warna background field input tanggal
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        _tanggalC.text = DateFormat("d MMMM y", "id_ID")
                            .format(pickedDate ?? DateTime.now());
                      },
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Tanggal Lahir:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _noHPC,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'No HP:',
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    BlocBuilder<ReligionCubit, String?>(
                      builder: (context, selectedValue) {
                        final cubit = context.read<ReligionCubit>();
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Agama",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedValue,
                          items: cubit.items.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            context.read<ReligionCubit>().selectItem(value);
                          },
                        );
                      },
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
                        context.read<ReligionCubit>().state == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Tolong isi semua kolom yang sudah tersedia',
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
                      userCreationReq.agama =
                          context.read<ReligionCubit>().state;
                      userCreationReq.gender =
                          context.read<GenderSelectionCubit>().selectedIndex;
                      FocusScope.of(context).unfocus();
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
