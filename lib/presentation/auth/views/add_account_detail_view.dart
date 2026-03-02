import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/get_all_kelas_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/religion/religion_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/widgets/scan_qr_nisn.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/field/basic_text_field.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../common/widget/photo/add_photo_view.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../core/constants/static_text.dart';
import '../../../domain/entities/auth/user_golang.dart';
import '../../../domain/usecases/auth/signup.dart';
import '../bloc/password_cubit.dart';
import '../widgets/button_role.dart';
import 'login_view.dart';

class AddAccountView extends StatefulWidget {
  const AddAccountView({super.key});

  @override
  State<AddAccountView> createState() => _AddAccountViewState();
}

class _AddAccountViewState extends State<AddAccountView> {
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _kelasC = TextEditingController();
  final TextEditingController _nisnC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _noHPC = TextEditingController();
  final TextEditingController _alamatC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  late int kelasId;
  File? imageProfile;

  @override
  void dispose() {
    super.dispose();
    _namaC.dispose();
    _kelasC.dispose();
    _nisnC.dispose();
    _tanggalC.dispose();
    _noHPC.dispose();
    _alamatC.dispose();
    _emailC.dispose();
    _passC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    DateFormat formatter = DateFormat("d MMMM y", "id_ID");

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
          BlocProvider(
            create: (context) => GetAllKelasCubit()..displayAll(),
          ),
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (context) => PasswordCubit(),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccesPage(
                    page: LoginView(),
                    title: StaticText.succesRegister,
                  ),
                ),
                (route) => route.isFirst,
              );
            }
          },
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BasicAppbar(
                  isBackViewed: true,
                  isProfileViewed: false,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                        child: Text(
                          'Data Akun:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      BasicTextField(
                        controller: _emailC,
                        hintText: "Email:",
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<PasswordCubit, bool>(
                        builder: (context, state) {
                          return TextField(
                            obscureText: state,
                            controller: _passC,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'password:',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  context
                                      .read<PasswordCubit>()
                                      .togglePasswordVisibility();
                                },
                                icon: Icon(
                                  state
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
                        child: Text(
                          'Data Pribadi:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      BasicTextField(
                        controller: _namaC,
                        hintText: "Nama:",
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
                            return DropdownMenu<int>(
                              width: width * 0.92,
                              inputDecorationTheme: const InputDecorationTheme(
                                fillColor: AppColors.tertiary,
                                filled: true,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              menuHeight: 200,
                              hintText: 'Kelas',
                              dropdownMenuEntries: state.kelas.map((doc) {
                                return DropdownMenuEntry<int>(
                                  value: doc.id ?? 0,
                                  label: doc.className,
                                );
                              }).toList(),
                              onSelected: (value) {
                                if (value != null) {
                                  setState(() {
                                    kelasId = value;
                                  });
                                }
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      TextField(
                        controller: _nisnC,
                        keyboardType: TextInputType.number,
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
                                fontWeight: FontWeight.w300,
                                color: Colors.black, // <-- warna hint
                              ),
                            ),
                            menuHeight: 200,
                            hintText: "Agama:",
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
                                      builder: (context) => AddPhotoView(
                                        name: _namaC.text,
                                        id: _nisnC.text,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      imageProfile = result;
                                    });
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
                                          "Tambah Foto",
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
                      SizedBox(height: height * 0.02),
                      imageProfile != null
                          ? Row(
                              children: [
                                const Text(
                                  'Tampilan Foto: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(imageProfile!),
                                        fit: BoxFit.fill),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return ButtonRole(
                    onPressed: () {
                      if (_namaC.text.isEmpty ||
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
                        context.read<ButtonStateCubit>().execute(
                              usecase: SignUpUseCase(),
                              params: UserGolang(
                                address: _alamatC.text,
                                email: _emailC.text,
                                nisn: _nisnC.text,
                                name: _namaC.text,
                                kelasId: kelasId,
                                mobileNum: _noHPC.text,
                                password: _passC.text,
                                religion: context.read<ReligionCubit>().state,
                                isAdmin: false,
                                isRegister: false,
                                gender: context
                                    .read<GenderSelectionCubit>()
                                    .selectedIndex,
                                birthDate: formatter.parse(_tanggalC.text),
                                imageFile: imageProfile,
                              ),
                            );
                      }
                    },
                    title: 'Simpan',
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
