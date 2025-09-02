import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageTeacher/views/ack_add_teacher_view.dart';

import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddTeacherView extends StatelessWidget {
  AddTeacherView({
    super.key,
  });
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _mengajarC = TextEditingController();
  final TextEditingController _nipC = TextEditingController();
  final TextEditingController _waliKelasC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _jabatanC = TextEditingController();

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
      body: BlocProvider(
        create: (context) => GetAllKelasCubit()..displayAll(),
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
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == 3) {
                          return BlocBuilder<GetAllKelasCubit,
                              KelasDisplayState>(
                            builder: (context, state) {
                              if (state is KelasDisplayLoading) {
                                return TextField(
                                  controller: _waliKelasC,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                    hintText: 'Wali Kelas:',
                                  ),
                                );
                              }
                              if (state is KelasDisplayLoaded) {
                                return DropdownMenu<String>(
                                  width: width * 0.92,
                                  inputDecorationTheme:
                                      const InputDecorationTheme(
                                    fillColor: AppColors.tertiary,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black, // <-- warna hint
                                    ),
                                  ),
                                  menuHeight: 200,
                                  hintText: 'Wali Kelas:',
                                  dropdownMenuEntries: state.kelas.map((doc) {
                                    final kelas = doc.kelas;
                                    return DropdownMenuEntry(
                                      value: kelas,
                                      label: kelas,
                                    );
                                  }).toList(),
                                  onSelected: (value) {
                                    context
                                        .read<GetAllKelasCubit>()
                                        .selectItem(value);
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          );
                        } else if (index == 4) {
                          return TextField(
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
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        filled: true,
                                        fillColor: AppColors
                                            .inversePrimary, // warna background field input tanggal
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                          );
                        } else {
                          return TextField(
                            controller: controller[index],
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: hinttext[index],
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: height * 0.01,
                      ),
                      itemCount: 6,
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                return BasicButton(
                  onPressed: () {
                    if (_namaC.text.isEmpty ||
                        _nipC.text.isEmpty ||
                        _mengajarC.text.isEmpty ||
                        _tanggalC.text.isEmpty) {
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
                          teacherCreationReq: TeacherModel(
                            nama: _namaC.text,
                            mengajar: _mengajarC.text,
                            nip: _nipC.text,
                            tanggalLahir: _tanggalC.text,
                            waliKelas: cubit is KelasDisplayLoaded &&
                                    cubit.selected == null
                                ? '-'
                                : (cubit as KelasDisplayLoaded).selected!,
                            jabatan:
                                _jabatanC.text.isEmpty ? '-' : _jabatanC.text,
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
}
