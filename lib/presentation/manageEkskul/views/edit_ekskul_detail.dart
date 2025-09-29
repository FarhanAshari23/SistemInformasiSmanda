import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/ekskul/ekskul_cubit.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/common/widget/searchbar/search_students_view.dart';
import 'package:new_sistem_informasi_smanda/common/widget/searchbar/search_teachers_views.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/card/card_anggota.dart';
import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/usecases/ekskul/update_ekskul.dart';
import '../../../service_locator.dart';

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
  late TextEditingController _namePembinaC;
  late TextEditingController _nameKetuaC;
  late TextEditingController _nameWakilC;
  late TextEditingController _nameSekretarisC;
  late TextEditingController _nameBendaharaC;
  late TextEditingController _deskripsiC;

  @override
  void initState() {
    super.initState();
    _nameEkskulC = TextEditingController(text: widget.ekskul.namaEkskul);
    _namePembinaC = TextEditingController(text: widget.ekskul.namaPembina);
    _nameKetuaC = TextEditingController(text: widget.ekskul.namaKetua);
    _nameWakilC = TextEditingController(text: widget.ekskul.namaWakilKetua);
    _nameSekretarisC =
        TextEditingController(text: widget.ekskul.namaSekretaris);
    _nameBendaharaC = TextEditingController(text: widget.ekskul.namaBendahara);
    _deskripsiC = TextEditingController(text: widget.ekskul.deskripsi);
  }

  @override
  void dispose() {
    super.dispose();
    _nameEkskulC.dispose();
    _namePembinaC.dispose();
    _nameKetuaC.dispose();
    _nameWakilC.dispose();
    _nameSekretarisC.dispose();
    _nameBendaharaC.dispose();
    _deskripsiC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<String> jabatan = ['Ketua', 'Wakil Ketua', 'Sekretaris', 'Bendahara'];
    List<TextEditingController> nama = [
      _nameKetuaC,
      _nameWakilC,
      _nameSekretarisC,
      _nameBendaharaC,
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const BasicAppbar(isBackViewed: true, isProfileViewed: false),
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
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Deskripsi:",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      widget.ekskul.deskripsi,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
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
                          widget.ekskul.namaEkskul,
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
                              builder: (context) {
                                return Container(
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
                                      const Text(
                                        "Nama ekskul:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      TextField(
                                        autocorrect: false,
                                        controller: _nameEkskulC,
                                      ),
                                      BasicButton(
                                        onPressed: () => Navigator.pop(context),
                                        title: 'Ubah',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
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
                  CardAnggota(
                    title: _namePembinaC.text,
                    desc: "Pembina",
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchTeachersViews(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _namePembinaC.text = result;
                        });
                      }
                    },
                  ),
                  SizedBox(height: height * 0.01),
                  ...List.generate(jabatan.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CardAnggota(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchStudentsView(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              nama[index].text = result;
                            });
                          }
                        },
                        title: nama[index].text,
                        desc: jabatan[index],
                      ),
                    );
                  }),
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
                  widget.ekskul.anggota.isEmpty
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
                            final anggota = widget.ekskul.anggota[index];
                            return CardAnggota(
                              onTap: () {},
                              title: anggota.nama,
                              desc: anggota.nisn,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemCount: widget.ekskul.anggota.length,
                        ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            BasicButton(
              onPressed: () async {
                if (_namePembinaC.text.isEmpty ||
                    _nameKetuaC.text.isEmpty ||
                    _nameWakilC.text.isEmpty ||
                    _nameSekretarisC.text.isEmpty ||
                    _nameBendaharaC.text.isEmpty ||
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
                  var result = await sl<UpdateEkskulUsecase>().call(
                      params: EkskulEntity(
                    namaEkskul: _nameEkskulC.text,
                    namaPembina: _namePembinaC.text,
                    namaKetua: _nameKetuaC.text,
                    namaWakilKetua: _nameWakilC.text,
                    namaSekretaris: _nameSekretarisC.text,
                    namaBendahara: _nameBendaharaC.text,
                    deskripsi: _deskripsiC.text,
                    anggota: [],
                  ));
                  result.fold(
                    (error) {
                      var snackbar = const SnackBar(
                        content: Text("Gagal Mengubah Data"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    (r) {
                      var snackbar = const SnackBar(
                        content: Text("Data Berhasil Diubah"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      context.read<EkskulCubit>().displayEkskul();
                      Navigator.pop(context);
                    },
                  );
                }
              },
              title: "Ubah",
            ),
          ],
        ),
      ),
    );
  }
}
