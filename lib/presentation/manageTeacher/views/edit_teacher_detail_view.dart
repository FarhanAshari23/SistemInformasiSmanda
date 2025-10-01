import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/teacher/teacher_cubit.dart';

import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/teacher/update_teacher.dart';
import '../../../service_locator.dart';

class EditTeacherDetailView extends StatefulWidget {
  final TeacherEntity teacher;
  const EditTeacherDetailView({super.key, required this.teacher});

  @override
  State<EditTeacherDetailView> createState() => _EditTeacherDetailViewState();
}

class _EditTeacherDetailViewState extends State<EditTeacherDetailView> {
  late TextEditingController _namaC;
  late TextEditingController _mengajarC;
  late TextEditingController _nipC;
  late TextEditingController _waliKelasC;
  late TextEditingController _tanggalC;
  late TextEditingController _jabatanC;

  @override
  void initState() {
    super.initState();
    _namaC = TextEditingController(text: widget.teacher.nama);
    _mengajarC = TextEditingController(text: widget.teacher.mengajar);
    _nipC = TextEditingController(text: widget.teacher.nip);
    _waliKelasC = TextEditingController(text: widget.teacher.waliKelas);
    _tanggalC = TextEditingController(text: widget.teacher.tanggalLahir);
    _jabatanC = TextEditingController(text: widget.teacher.jabatan);
  }

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
            create: (context) {
              final cubit = GenderSelectionCubit();
              cubit.selectGender(widget.teacher.gender ?? 0);
              return cubit;
            },
          ),
        ],
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BasicAppbar(
                isBackViewed: true,
                isProfileViewed: false,
              ),
              const Center(
                child: Text(
                  'EDIT DATA GURU',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: height * 0.04),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Masukan informasi yang sesuai pada kolom berikut:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
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
                                    hintText: 'kelas:',
                                  ),
                                );
                              }
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
                                  hintText: widget.teacher.waliKelas,
                                  dropdownMenuEntries: entries,
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
                        } else if (index == 6) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Jenis Kelamin: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.primary,
                                  ),
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
                      itemCount: 7,
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                return BasicButton(
                  onPressed: () async {
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
                      var result = await sl<UpdateTeacherUsecase>().call(
                        params: TeacherEntity(
                          nama: _namaC.text,
                          mengajar: _mengajarC.text,
                          nip: _nipC.text,
                          tanggalLahir: _tanggalC.text,
                          waliKelas: cubit is KelasDisplayLoaded &&
                                  cubit.selected == null
                              ? '-'
                              : (cubit as KelasDisplayLoaded).selected!,
                          jabatan: _jabatanC.text,
                          gender: context
                              .read<GenderSelectionCubit>()
                              .selectedIndex,
                        ),
                      );
                      result.fold(
                        (error) {
                          var snackbar = const SnackBar(
                            content: Text("Gagal Mengubah Data"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        },
                        (r) {
                          context.read<TeacherCubit>().displayTeacher();
                          var snackbar = const SnackBar(
                            content: Text("Data Berhasil Diubah"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          Navigator.pop(context);
                        },
                      );
                    }
                  },
                  title: 'Ubah',
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
