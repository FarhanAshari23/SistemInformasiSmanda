import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/common/widget/photo/change_photo_view.dart';
import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/ekskul/ekskul_cubit.dart';
import '../../../../common/helper/display_image.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../common/widget/button/basic_button.dart';
import '../../../../common/widget/card/card_anggota.dart';
import '../../../../common/widget/dialog/basic_dialog.dart';
import '../../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../../common/widget/photo/network_photo.dart';
import '../../../../common/widget/searchbar/search_students_view.dart';
import '../../../../common/widget/searchbar/search_teachers_views.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/ekskul/advisor.dart';
import '../../../../domain/entities/ekskul/member.dart';
import '../../../../domain/entities/student/student.dart';
import '../../../../domain/entities/ekskul/ekskul.dart';
import '../../../../domain/entities/teacher/teacher.dart';
import '../../../../domain/usecases/ekskul/update_ekskul.dart';
import '../bloc/edit_state_button_cubit.dart';

class EditEkskulDetail extends StatefulWidget {
  final EkskulEntity ekskul;
  const EditEkskulDetail({
    super.key,
    required this.ekskul,
  });

  @override
  State<EditEkskulDetail> createState() => _EditEkskulDetailState();
}

class _EditEkskulDetailState extends State<EditEkskulDetail> {
  late TextEditingController _nameEkskulC;
  late List<TextEditingController> _controllers;
  late TextEditingController _nameKetuaC;
  late TextEditingController _nameWakilC;
  late TextEditingController _nameSekretarisC;
  late TextEditingController _nameBendaharaC;
  late TextEditingController _deskripsiC;
  late List<AdvisorEntity> selectedPembina;
  List<MemberEntity>? selectedAnggota;
  File? logo;

  @override
  void initState() {
    super.initState();

    selectedAnggota = List.from(widget.ekskul.members ?? []);
    selectedPembina = List.from(widget.ekskul.advisors ?? []);
    _controllers = [];

    MemberEntity findRole(String role) => selectedAnggota!.firstWhere(
          (e) => e.role == role,
          orElse: () => MemberEntity(role: role, name: ''),
        );

    _nameEkskulC = TextEditingController(text: widget.ekskul.nameEkskul);
    _nameKetuaC = TextEditingController(text: findRole("Ketua").name);
    _nameWakilC = TextEditingController(text: findRole("Wakil Ketua").name);
    _nameSekretarisC = TextEditingController(text: findRole("Sekretaris").name);
    _nameBendaharaC = TextEditingController(text: findRole("Bendahara").name);
    _deskripsiC = TextEditingController(text: widget.ekskul.description);

    for (var pembina in selectedPembina) {
      _controllers.add(TextEditingController(text: pembina.name));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameEkskulC.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    _nameKetuaC.dispose();
    _nameWakilC.dispose();
    _nameSekretarisC.dispose();
    _nameBendaharaC.dispose();
    _deskripsiC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ketua = selectedAnggota?.firstWhere((e) => e.role == "Ketua",
            orElse: () => MemberEntity(role: "Ketua")) ??
        MemberEntity(role: "Ketua");
    final wakil = selectedAnggota?.firstWhere((e) => e.role == "Wakil Ketua",
            orElse: () => MemberEntity(role: "Wakil Ketua")) ??
        MemberEntity(role: "Wakil Ketua");
    final sekretaris = selectedAnggota?.firstWhere(
            (e) => e.role == "Sekretaris",
            orElse: () => MemberEntity(role: "Sekretaris")) ??
        MemberEntity(role: "Sekretaris");
    final bendahara = selectedAnggota?.firstWhere((e) => e.role == "Bendahara",
            orElse: () => MemberEntity(role: "Bendahara")) ??
        MemberEntity(role: "Bendahara");
    List<MemberEntity> members = selectedAnggota
            ?.where((element) => element.role == "Anggota")
            .toList() ??
        [];
    double height = MediaQuery.of(context).size.height;
    List<String> jabatan = ['Ketua', 'Wakil Ketua', 'Sekretaris', 'Bendahara'];
    List<MemberEntity> roleEntity = [ketua, wakil, sekretaris, bendahara];
    List<TextEditingController> nama = [
      _nameKetuaC,
      _nameWakilC,
      _nameSekretarisC,
      _nameBendaharaC,
    ];
    DateTime now = DateTime.now();
    String customId = DateFormat('MMyyyy').format(now);
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ButtonStateCubit(),
          ),
          BlocProvider(
            create: (context) => EditStateButtonCubit(),
          ),
        ],
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonLoadingState) return;
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              final actionType = context.read<EditStateButtonCubit>().state;
              if (actionType == 'ubah') {
                context.read<EkskulCubit>().displayEkskul();
              }
              var snackbar = SnackBar(
                content: Text(actionType == 'ubah'
                    ? "Data Berhasil Diubah"
                    : "Anggota berhasil dihapus"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            }
          },
          child: SafeArea(
            child: ListView(
              children: [
                const BasicAppbar(isBackViewed: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomInkWell(
                            borderRadius: 8,
                            defaultColor: AppColors.primary,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder: (_) {
                                  return SafeArea(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              "Deskripsi:",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: TextField(
                                              autocorrect: false,
                                              maxLines: 7,
                                              controller: _deskripsiC,
                                            ),
                                          ),
                                          BasicButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            title: 'Simpan',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Row(
                          children: [
                            Text(
                              _nameEkskulC.text,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CustomInkWell(
                              borderRadius: 999,
                              defaultColor: AppColors.primary,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (_) {
                                    return SafeArea(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 16),
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                "Nama ekskul:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                              child: TextField(
                                                autocorrect: false,
                                                controller: _nameEkskulC,
                                              ),
                                            ),
                                            BasicButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              title: 'Ubah',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.inversePrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      ...List.generate(
                        selectedPembina.length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: height * 0.01),
                            child: CardAnggota(
                              pembina: selectedPembina[index],
                              title: _controllers[index].text,
                              desc: "Pembina",
                              onTap: () async {
                                TeacherEntity result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchTeachersViews(),
                                  ),
                                );
                                setState(() {
                                  selectedPembina[index] = AdvisorEntity(
                                    id: result.id,
                                    status: "Aktif",
                                    birthDate: result.birthDate,
                                    gender: result.gender,
                                    name: result.name,
                                    nip: result.nip,
                                    picture: result.picture,
                                  );
                                  _controllers[index].text = result.name ?? '';
                                });
                              },
                            ),
                          );
                        },
                      ),
                      ...List.generate(jabatan.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CardAnggota(
                            onTap: () async {
                              StudentEntity result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchStudentsView(),
                                ),
                              );
                              setState(() {
                                String role = "";
                                TextEditingController? targetController;
                                switch (index) {
                                  case 0:
                                    role = "Ketua";
                                    targetController = _nameKetuaC;
                                    break;
                                  case 1:
                                    role = "Wakil Ketua";
                                    targetController = _nameWakilC;
                                    break;
                                  case 2:
                                    role = "Sekretaris";
                                    targetController = _nameSekretarisC;
                                    break;
                                  case 3:
                                    role = "Bendahara";
                                    targetController = _nameBendaharaC;
                                    break;
                                }
                                if (role.isNotEmpty) {
                                  selectedAnggota!.removeWhere(
                                    (element) => element.role == role,
                                  );
                                  selectedAnggota!.add(MemberEntity(
                                    id: result.id,
                                    role: role,
                                    gender: result.gender,
                                    name: result.name,
                                    nisn: result.nisn,
                                    picture: result.picture,
                                    religion: result.religion,
                                  ));
                                  targetController?.text = result.name ?? '';
                                }
                              });
                            },
                            murid: roleEntity[index],
                            title: nama[index].text,
                            desc: jabatan[index],
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomInkWell(
                            borderRadius: 12,
                            defaultColor: AppColors.secondary,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePhotoView(
                                    picture:
                                        "${widget.ekskul.nameEkskul}_$customId",
                                  ),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  logo = result;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    logo != null ? "Ubah Foto" : "Tambah Foto",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          logo != null
                              ? Container(
                                  width: height * 0.1,
                                  height: height * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(logo!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: NetworkPhoto(
                                    width: height * 0.1,
                                    height: height * 0.1,
                                    imageUrl: DisplayImage.displayImageEkskul(
                                        widget.ekskul.picture!),
                                    fallbackAsset: AppImages.eskul,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Anggota:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      members.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    AppImages.emptyRegistrationChara,
                                    width: 120,
                                    height: 120,
                                  ),
                                  const Text(
                                    'Belum ada anggota',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final anggota = members[index];
                                return CardAnggota(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BasicDialog(
                                          splashImage: AppImages.notfound,
                                          mainTitle:
                                              'Apakah anda yakin ingin mengeluarkan ${anggota.name} dari ekskul ${widget.ekskul.nameEkskul}?',
                                          buttonTitle: 'Hapus',
                                          onPressed: () {
                                            setState(() {
                                              selectedAnggota!.removeWhere(
                                                  (element) =>
                                                      element.nisn ==
                                                      anggota.nisn);
                                            });
                                          },
                                        );
                                      },
                                    );
                                  },
                                  murid: anggota,
                                  title: anggota.name ?? '',
                                  desc: anggota.nisn ?? '',
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemCount: members.length,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Builder(builder: (context) {
                  return BasicButton(
                    onPressed: () async {
                      if (_nameEkskulC.text.isEmpty ||
                          _deskripsiC.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Tolong isi semua kolom yang tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else {
                        List<MemberEntity> finalMembers = [];
                        finalMembers
                            .addAll(roleEntity.where((e) => e.id != null));
                        finalMembers.addAll(members);
                        context
                            .read<EditStateButtonCubit>()
                            .updateValue('ubah');
                        context.read<ButtonStateCubit>().execute(
                              usecase: UpdateEkskulUsecase(),
                              params: EkskulEntity(
                                id: widget.ekskul.id,
                                advisors: selectedPembina,
                                description: _deskripsiC.text,
                                members: finalMembers,
                                nameEkskul: _nameEkskulC.text,
                                imageFile: logo,
                              ),
                            );
                      }
                    },
                    title: "Ubah",
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
