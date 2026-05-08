import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/helper/app_navigation.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../common/widget/landing/succes.dart';
import '../../../../common/widget/searchbar/search_students_view.dart';
import '../../../../common/widget/searchbar/search_teachers_views.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/entities/ekskul/advisor.dart';
import '../../../../domain/entities/ekskul/member.dart';
import '../../../../domain/entities/ekskul/ekskul.dart';
import '../../../../domain/usecases/ekskul/create_ekskul.dart';
import '../../../auth/widgets/button_role.dart';
import '../../../home/views/home_view_admin.dart';

class AddDataEkskulView extends StatefulWidget {
  const AddDataEkskulView({super.key});

  @override
  State<AddDataEkskulView> createState() => _AddDataEkskulViewState();
}

class _AddDataEkskulViewState extends State<AddDataEkskulView> {
  final List<TextEditingController> _controllers = [];
  final TextEditingController _namaEkskulC = TextEditingController();
  final TextEditingController _nameKetuaC = TextEditingController();
  final TextEditingController _nameWakilC = TextEditingController();
  final TextEditingController _nameSekretarisC = TextEditingController();
  final TextEditingController _nameBendaharaC = TextEditingController();
  final TextEditingController _deskripsiC = TextEditingController();

  final List<AdvisorEntity> _selectedPembina = [];
  final List<MemberEntity> members = [];

  @override
  void initState() {
    super.initState();
    _addTextField();
  }

  void _addTextField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
    _namaEkskulC.dispose();
    _nameKetuaC.dispose();
    _nameWakilC.dispose();
    _nameSekretarisC.dispose();
    _nameBendaharaC.dispose();
    _deskripsiC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    List<TextEditingController> listC = [
      _nameKetuaC,
      _nameWakilC,
      _nameSekretarisC,
      _nameBendaharaC,
    ];
    List<String> hintText = [
      'Nama Ketua',
      'Nama Wakil Ketua',
      'Nama Sekretaris',
      'Nama Bendahara',
    ];

    return BlocProvider(
      create: (context) => ButtonStateCubit(),
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
            AppNavigator.push(
              context,
              const SuccesPage(
                page: HomeViewAdmin(),
                title: 'Data Ekskul Berhasil Ditambahkan',
              ),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(isBackViewed: true),
                SizedBox(height: height * 0.01),
                const Text(
                  'TAMBAH EKSKUL',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.02),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.vertical,
                    children: [
                      TextField(
                        controller: _namaEkskulC,
                        maxLines: 1,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Nama Ekstrakulikuler:',
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ListView.separated(
                        itemBuilder: (context, index) {
                          return TextField(
                            readOnly: true,
                            controller: _controllers[index],
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: hintText[index],
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onTap: () async {
                              final route = MaterialPageRoute(
                                  builder: (_) => const SearchTeachersViews());

                              final result =
                                  await Navigator.push(context, route);

                              if (result != null) {
                                setState(() {
                                  _selectedPembina.add(AdvisorEntity(
                                    id: result.id,
                                    status: "Aktif",
                                    birthDate: result.birthDate,
                                    gender: result.gender,
                                    name: result.name,
                                    nip: result.nip,
                                    picture: result.picture,
                                  ));
                                });
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: height * 0.01,
                        ),
                        itemCount: listC.length,
                      ),
                      Column(
                        children: List.generate(
                          4,
                          (index) {
                            return TextField(
                              readOnly: true,
                              controller: listC[index],
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: hintText[index],
                                labelStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () async {
                                final route = MaterialPageRoute(
                                    builder: (_) => const SearchStudentsView());

                                final result =
                                    await Navigator.push(context, route);

                                if (result != null) {
                                  setState(() {
                                    String role = "";
                                    TextEditingController? targetController;
                                    switch (index) {
                                      case 1:
                                        role = "Ketua";
                                        targetController = _nameKetuaC;
                                        break;
                                      case 2:
                                        role = "Wakil Ketua";
                                        targetController = _nameWakilC;
                                        break;
                                      case 3:
                                        role = "Sekretaris";
                                        targetController = _nameSekretarisC;
                                        break;
                                      case 4:
                                        role = "Bendahara";
                                        targetController = _nameBendaharaC;
                                        break;
                                    }
                                    if (role.isNotEmpty) {
                                      members.add(MemberEntity(
                                        id: result.id,
                                        role: role,
                                        gender: result.gender,
                                        name: result.name,
                                        nisn: result.nisn,
                                        picture: result.picture,
                                        religion: result.religion,
                                      ));
                                      targetController?.text =
                                          result.name ?? '';
                                    }
                                  });
                                }
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return ButtonRole(
                    onPressed: () {
                      if (_namaEkskulC.text.isEmpty ||
                          _selectedPembina.isEmpty ||
                          members.isEmpty ||
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
                        context.read<ButtonStateCubit>().execute(
                              usecase: CreateEkskulUseCase(),
                              params: EkskulEntity(
                                advisors: _selectedPembina,
                                description: _deskripsiC.text,
                                members: members,
                                nameEkskul: _namaEkskulC.text,
                              ),
                            );
                        FocusScope.of(context).unfocus();
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
