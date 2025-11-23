import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../common/widget/dropdown/app_dropdown_field.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/add_photo_view.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/auth/teacher.dart';
import 'ack_add_teacher_view.dart';
import 'select_jabatan_view.dart';
import 'select_mengajar_view.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({
    super.key,
  });

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _mengajarC = TextEditingController();
  final TextEditingController _nipC = TextEditingController();
  final TextEditingController _waliKelasC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _jabatanC = TextEditingController();
  late File? imageProfile;

  @override
  void dispose() {
    super.dispose();
    _namaC.dispose();
    _mengajarC.dispose();
    _nipC.dispose();
    _waliKelasC.dispose();
    _tanggalC.dispose();
    _jabatanC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> hinttext = [
      'Nama:',
      'Mengajar:',
      'NIP:',
      'Wali kelas:',
      'Tanggal Lahir:',
      'Jabatan Tambahan:'
    ];
    List<TextEditingController> controller = [
      _namaC,
      _mengajarC,
      _nipC,
      _waliKelasC,
      _tanggalC,
      _jabatanC,
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetAllKelasCubit()..displayAll(),
          ),
          BlocProvider(
            create: (context) => GenderSelectionCubit(),
          ),
        ],
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
              SizedBox(height: height * 0.04),
              const Text(
                'Masukan informasi yang sesuai pada kolom berikut:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(7, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01),
                        child: _buildFieldByIndex(
                          context: context,
                          index: index,
                          width: width,
                          height: height,
                          hinttext: hinttext,
                          controller: controller,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Builder(builder: (context) {
                return BasicButton(
                  onPressed: () {
                    if (_namaC.text.isEmpty || _tanggalC.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Tolong isi semua kolom yang sudah disediakan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final cubit = context.read<GetAllKelasCubit>().state;
                      AppNavigator.push(
                        context,
                        AckAddTeacherView(
                          teacherCreationReq: TeacherEntity(
                            nama: _namaC.text,
                            mengajar:
                                _mengajarC.text.isEmpty ? '-' : _mengajarC.text,
                            nip: _nipC.text.isEmpty ? '-' : _nipC.text,
                            tanggalLahir: _tanggalC.text,
                            waliKelas: cubit is KelasDisplayLoaded &&
                                    cubit.selected == null
                                ? '-'
                                : (cubit as KelasDisplayLoaded).selected!,
                            jabatan:
                                _jabatanC.text.isEmpty ? '-' : _jabatanC.text,
                            gender: context
                                .read<GenderSelectionCubit>()
                                .selectedIndex,
                            image: imageProfile,
                          ),
                        ),
                      );
                    }
                  },
                  title: 'Lanjut',
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldByIndex({
    required BuildContext context,
    required int index,
    required double width,
    required double height,
    required List<String> hinttext,
    required List<TextEditingController> controller,
  }) {
    if (index == 3) {
      // Dropdown Wali Kelas
      return BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
        builder: (context, state) {
          if (state is KelasDisplayLoaded) {
            final entries = state.kelas.map((doc) {
              final kelas = doc.kelas;
              return DropdownMenuEntry(
                value: kelas,
                label: kelas,
              );
            }).toList();
            entries.add(
              const DropdownMenuEntry<String>(
                value: "-", // ini yang nanti ke-save
                label: "Bukan Wali Kelas",
              ),
            );
            return AppDropdownField(
                width: width * 0.92,
                hint: 'Wali Kelas:',
                items: entries,
                onSelected: (value) {
                  context.read<GetAllKelasCubit>().selectItem(value);
                  FocusScope.of(context).unfocus();
                });
          }
          if (state is KelasDisplayLoading) {
            return TextField(
              controller: controller[index],
              decoration: InputDecoration(
                hintText: hinttext[index],
              ),
            );
          }
          return const SizedBox();
        },
      );
    } else if (index == 1) {
      // Dropdown Mengajar
      return TextField(
        controller: controller[index],
        readOnly: true,
        decoration: InputDecoration(
          hintText: hinttext[index],
          suffixIcon: IconButton(
            onPressed: () {
              controller[index].text = '';
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectMengajarView(),
            ),
          );
          if (result != null) {
            String hasil = result.join(", ");
            controller[index].text = hasil;
          }
        },
      );
    } else if (index == 4) {
      // Tanggal Picker
      return TextField(
        controller: controller[index],
        readOnly: true,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
            locale: const Locale('id', 'ID'),
          );
          if (picked != null) {
            controller[index].text =
                DateFormat("d MMMM y", "id_ID").format(picked);
          }
        },
        decoration: InputDecoration(hintText: hinttext[index]),
      );
    } else if (index == 6) {
      // Gender Selection
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Kelamin: ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              BlocBuilder<GenderSelectionCubit, int>(
                builder: (context, state) {
                  return Column(
                    children: [
                      BoxGender(
                        gender: 'Laki-laki',
                        context: context,
                        genderIndex: 1,
                      ),
                      SizedBox(height: width * 0.01),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomInkWell(
                borderRadius: 12,
                defaultColor: AppColors.secondary,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPhotoView(
                        name: controller[0].text,
                        id: controller[2].text.isEmpty
                            ? controller[2].text
                            : controller[4].text,
                      ),
                    ),
                  );
                  if (result != null) {
                    imageProfile = result;
                  }
                },
                child: SizedBox(
                    height: height * 0.12,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Ambil Photo",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
              ),
            ),
          )
        ],
      );
    } else if (index == 5) {
      //jabatan_tambahan
      return TextField(
        controller: controller[index],
        readOnly: true,
        decoration: InputDecoration(
          hintText: hinttext[index],
          suffixIcon: IconButton(
            onPressed: () {
              controller[index].text = '';
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectJabatanView(),
            ),
          );
          if (result != null) {
            String hasil = result.join(", ");
            controller[index].text = hasil;
          }
        },
      );
    }

    // Default TextField
    return TextField(
      controller: controller[index],
      decoration: InputDecoration(
        hintText: hinttext[index],
      ),
    );
  }
}
