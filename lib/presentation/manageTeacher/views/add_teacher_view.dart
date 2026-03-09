import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher_golang.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/create_teacher.dart';

import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/gender/gender_selection_cubit.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../common/widget/card/box_gender.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../common/widget/photo/add_photo_view.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/role.dart';
import 'select_jabatan_view.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({
    super.key,
  });

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final TextEditingController _namaC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _nipC = TextEditingController();
  final TextEditingController _tanggalC = TextEditingController();
  final TextEditingController _jabatanC = TextEditingController();
  File? imageProfile;
  late DateTime birthDate;
  List<int> id = [];
  DateFormat formatter = DateFormat("d MMMM y", "id_ID");

  @override
  void dispose() {
    super.dispose();
    _namaC.dispose();
    _emailC.dispose();
    _nipC.dispose();
    _tanggalC.dispose();
    _jabatanC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> hinttext = [
      'Nama:',
      'Email:',
      'NIP:',
      'Tanggal Lahir:',
      'Tugas Tambahan:'
    ];
    List<TextEditingController> controller = [
      _namaC,
      _emailC,
      _nipC,
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
              var snackbar = SnackBar(
                content: Text(state.successMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
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
                              'Tolong isi minimal kolom nama dan tanggal lahir',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        DateTime date = DateFormat("d MMMM yyyy", "id_ID")
                            .parse(_tanggalC.text);
                        String password = DateFormat("ddMMyyyy").format(date);
                        context.read<ButtonStateCubit>().execute(
                              usecase: CreateTeacherUseCase(),
                              params: TeacherGolangEntity(
                                email: _emailC.text,
                                name: _namaC.text,
                                nip: _nipC.text,
                                password: password,
                                tasksId: id,
                                birthDate: birthDate,
                                gender: context
                                    .read<GenderSelectionCubit>()
                                    .selectedIndex,
                                imageFile: imageProfile,
                              ),
                            );
                      }
                    },
                    title: 'Simpan',
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
  }) {
    if (index == 3) {
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
            setState(() {
              birthDate = picked;
            });
          }
        },
        decoration: InputDecoration(hintText: hinttext[index]),
      );
    } else if (index == 4) {
      return TextField(
        controller: controller[index],
        readOnly: true,
        decoration: InputDecoration(
          hintText: hinttext[index],
          suffixIcon: IconButton(
            onPressed: () {
              controller[index].text = '';
              id.clear();
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () async {
          List<RoleEntity>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectJabatanView(),
            ),
          );
          if (result != null) {
            List<String> name = [];
            for (var i = 0; i < result.length; i++) {
              name.add(result[i].name);
              id.add(result[i].id);
            }
            controller[index].text = name.join(", ");
          }
        },
      );
    } else if (index == 5) {
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
                        name: _namaC.text,
                        id: _nipC.text.isEmpty ? _tanggalC.text : _nipC.text,
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
    } else if (index == 6) {
      return imageProfile != null
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
                        image: FileImage(imageProfile!), fit: BoxFit.fill),
                  ),
                )
              ],
            )
          : const SizedBox();
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
