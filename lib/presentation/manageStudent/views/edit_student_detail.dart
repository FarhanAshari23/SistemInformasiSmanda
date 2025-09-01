import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/get_all_kelas_cubit.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/kelas/stundets_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../data/models/auth/update_user.dart';
import '../../../domain/usecases/students/update_user.dart';
import '../../../service_locator.dart';
import '../../../common/bloc/religion/religion_cubit.dart';
import '../../auth/widgets/scan_qr_nisn.dart';

class EditStudentDetail extends StatefulWidget {
  final UserEntity user;
  const EditStudentDetail({
    super.key,
    required this.user,
  });

  @override
  State<EditStudentDetail> createState() => _EditStudentDetailState();
}

class _EditStudentDetailState extends State<EditStudentDetail> {
  late TextEditingController _namaC;
  late TextEditingController _kelasC;
  late TextEditingController _nisnC;
  late TextEditingController _tanggalC;
  late TextEditingController _noHPC;
  late TextEditingController _alamatC;
  late TextEditingController _ekskulC;

  @override
  void initState() {
    super.initState();
    _namaC = TextEditingController(text: widget.user.nama);
    _kelasC = TextEditingController(text: widget.user.kelas);
    _nisnC = TextEditingController(text: widget.user.nisn);
    _tanggalC = TextEditingController(text: widget.user.tanggalLahir);
    _noHPC = TextEditingController(text: widget.user.noHP);
    _alamatC = TextEditingController(text: widget.user.alamat);
    _ekskulC = TextEditingController(text: widget.user.ekskul);
  }

  @override
  void dispose() {
    super.dispose();
    _namaC.dispose();
    _kelasC.dispose();
    _nisnC.dispose();
    _tanggalC.dispose();
    _noHPC.dispose();
    _alamatC.dispose();
    _ekskulC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = GenderSelectionCubit();
              cubit.selectGender(widget.user.gender ?? 0);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) {
              final cubit = ReligionCubit();
              cubit.selectItem(widget.user.agama);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) {
              final cubit = GetAllKelasCubit()..displayAll();
              cubit.selectItem(widget.user.kelas);
              return cubit;
            },
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
                'Ubah data siswa',
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
                    BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
                      builder: (context, state) {
                        if (state is KelasDisplayLoading) {
                          return TextField(
                            controller: _kelasC,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              hintText: 'kelas:',
                            ),
                          );
                        }
                        if (state is KelasDisplayLoaded) {
                          return DropdownMenu<String>(
                            width: width * 0.92,
                            inputDecorationTheme: const InputDecorationTheme(
                              fillColor: AppColors.tertiary,
                              filled: true,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black, // <-- warna hint
                              ),
                            ),
                            menuHeight: 200,
                            hintText: widget.user.kelas,
                            dropdownMenuEntries: state.kelas.map((doc) {
                              final kelas = doc.data()['class'] as String;
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
                                        child: const ScanQrNisn(),
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
                        return DropdownMenu<String>(
                          width: width * 0.92,
                          inputDecorationTheme: const InputDecorationTheme(
                            fillColor: AppColors.tertiary,
                            filled: true,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black, // <-- warna hint
                            ),
                          ),
                          menuHeight: 200,
                          hintText: widget.user.agama,
                          dropdownMenuEntries: cubit.items.map((doc) {
                            return DropdownMenuEntry(
                              value: doc,
                              label: doc,
                            );
                          }).toList(),
                          onSelected: (value) {
                            final cubit = context.read<ReligionCubit>();
                            if (value != null) {
                              cubit.selectItem(value);
                            }
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
                  onPressed: () async {
                    if (_namaC.text.isEmpty ||
                        _nisnC.text.isEmpty ||
                        _tanggalC.text.isEmpty ||
                        _noHPC.text.isEmpty ||
                        _alamatC.text.isEmpty ||
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
                      final cubit = context.read<GetAllKelasCubit>().state;
                      var result = await sl<UpdateStudentUsecase>().call(
                        params: UpdateUserReq(
                          nama: _namaC.text,
                          kelas: cubit is KelasDisplayLoaded &&
                                  cubit.selected != null
                              ? cubit.selected!
                              : widget.user.kelas!,
                          nisn: _nisnC.text,
                          tanggalLahir: _tanggalC.text,
                          noHp: _noHPC.text,
                          alamat: _alamatC.text,
                          ekskul: _ekskulC.text,
                          agama: context.read<ReligionCubit>().state!,
                          gender: context
                              .read<GenderSelectionCubit>()
                              .selectedIndex,
                        ),
                      );
                      result.fold((error) {
                        var snackbar = const SnackBar(
                          content: Text("Gagal Mengubah Data"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }, (r) {
                        context.read<StudentsDisplayCubit>().displayStudents(
                              params: _kelasC.text,
                            );
                        FocusScope.of(context).unfocus();
                        var snackbar = const SnackBar(
                          content: Text("Data Berhasil Diubah"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);

                        Navigator.pop(context);
                      });
                    }
                  },
                  title: 'Ubah',
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
