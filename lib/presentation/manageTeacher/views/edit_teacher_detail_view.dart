import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';

import '../../../common/bloc/activities/get_activities_cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../common/widget/dropdown/app_dropdown_field.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/teacher/update_teacher.dart';
import '../../auth/widgets/button_role.dart';
import '../../../common/widget/photo/change_photo_view.dart';
import 'select_jabatan_view.dart';
import 'select_mengajar_view.dart';

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
  File? imageProfile;

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
      'Tugas Tambahan:'
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
          BlocProvider(
            create: (context) => GetActivitiesCubit()..displayActivites(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
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
              context.read<TeacherCubit>().displayTeacher();
              var snackbar = SnackBar(
                content: Text(state.successMessage),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            }
          },
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
                            initMengajar: _mengajarC.text,
                            initWaliKelas: _waliKelasC.text,
                            controller: controller,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  return ButtonRole(
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
                        context.read<ButtonStateCubit>().execute(
                              usecase: UpdateTeacherUsecase(),
                              params: TeacherEntity(
                                uid: widget.teacher.uid,
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
                                image: imageProfile,
                              ),
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
    required String initWaliKelas,
    required String initMengajar,
  }) {
    if (index == 3) {
      // Dropdown Wali Kelas
      return BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
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
            return AppDropdownField(
              width: width * 0.92,
              hint: widget.teacher.waliKelas,
              items: entries,
              initSelection: initWaliKelas,
              onSelected: (value) {
                context.read<GetAllKelasCubit>().selectItem(value);
              },
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
      );
    } else if (index == 5) {
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
                      builder: (context) => ChangePhotoView(
                        teacher: widget.teacher,
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
                          "Ubah Photo",
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
