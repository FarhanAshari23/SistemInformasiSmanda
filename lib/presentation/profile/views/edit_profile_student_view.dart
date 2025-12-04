import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/bloc/religion/religion_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/change_photo_view.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../domain/entities/ekskul/update_anggota_req.dart';
import '../../../domain/usecases/ekskul/update_anggota_usecase.dart';
import '../../auth/widgets/button_role.dart';
import 'ekskul_selection_view.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../data/models/auth/update_user.dart';
import '../../../domain/usecases/students/update_user.dart';
import '../../../service_locator.dart';
import '../bloc/profile_info_cubit.dart';

class EditProfileStudentView extends StatefulWidget {
  final UserEntity? user;
  const EditProfileStudentView({
    super.key,
    this.user,
  });

  @override
  State<EditProfileStudentView> createState() => _EditProfileStudentViewState();
}

class _EditProfileStudentViewState extends State<EditProfileStudentView> {
  late TextEditingController _namaC;
  late TextEditingController _kelasC;
  late TextEditingController _nisnC;
  late TextEditingController _tanggalC;
  late TextEditingController _noHPC;
  late TextEditingController _alamatC;
  late TextEditingController _ekskulC;
  late File? imageProfile;

  @override
  void initState() {
    super.initState();
    _namaC = TextEditingController(text: widget.user?.nama);
    _kelasC = TextEditingController(text: widget.user?.kelas);
    _nisnC = TextEditingController(text: widget.user?.nisn);
    _tanggalC = TextEditingController(text: widget.user?.tanggalLahir);
    _noHPC = TextEditingController(text: widget.user?.noHP);
    _alamatC = TextEditingController(text: widget.user?.alamat);
    _ekskulC = TextEditingController(text: widget.user?.ekskul);
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
              cubit.selectGender(widget.user?.gender ?? 0);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) {
              final cubit = ReligionCubit();
              cubit.selectItem(widget.user?.agama);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) {
              final cubit = GetAllKelasCubit()..displayAll();
              cubit.selectItem(widget.user?.kelas);
              return cubit;
            },
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) async {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text("Gagal Mengubah Data: ${state.errorMessage}"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              var resultAnggota = await sl<UpdateAnggotaUsecase>().call(
                params: UpdateAnggotaReq(
                  namaEkskul: _ekskulC.text.split(', '),
                  anggota: widget.user!,
                ),
              );
              resultAnggota.fold(
                (error) {
                  var snackbar = SnackBar(
                    content: Text("Gagal Mengubah Data: $error"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                (r) {
                  context.read<ProfileInfoCubit>().getUser("Students");
                  FocusScope.of(context).unfocus();
                  var snackbar = const SnackBar(
                    content: Text("Data Berhasil Diubah"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);

                  Navigator.pop(context);
                },
              );
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                const Center(
                  child: Text(
                    'Ubah data profil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    '*nama, kelas, dan nisn tidak bisa diubah, silakan hubungi operator',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      TextField(
                        controller: _namaC,
                        autocorrect: false,
                        readOnly: true,
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
                              enabled: false,
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
                              hintText: widget.user?.kelas,
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
                      ),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: _nisnC,
                        autocorrect: false,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'NISN:',
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
                            hintText: widget.user?.agama,
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
                        readOnly: true,
                        maxLines: 4,
                        onTap: () async {
                          final existingEkskul = _ekskulC.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EkskulSelectionView(
                                initialEkskul: existingEkskul,
                              ),
                            ),
                          );
                          if (result != null) {
                            String hasil = result.join(", ");
                            _ekskulC.text = hasil;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Tuliskan ekskul disini...',
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
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
                                        user: widget.user,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return ButtonRole(
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
                        context.read<ButtonStateCubit>().execute(
                              usecase: UpdateStudentUsecase(),
                              params: UpdateUserReq(
                                nama: _namaC.text,
                                kelas: cubit is KelasDisplayLoaded &&
                                        cubit.selected != null
                                    ? cubit.selected!
                                    : widget.user?.kelas ?? '',
                                nisn: _nisnC.text,
                                tanggalLahir: _tanggalC.text,
                                noHp: _noHPC.text,
                                alamat: _alamatC.text,
                                ekskul: _ekskulC.text,
                                agama: context.read<ReligionCubit>().state!,
                                gender: context
                                    .read<GenderSelectionCubit>()
                                    .selectedIndex,
                                imageFile: imageProfile,
                              ),
                            );
                      }
                    },
                    title: 'Ubah',
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
