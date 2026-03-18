import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../common/widget/searchbar/search_students_view.dart';
import '../../../common/widget/searchbar/search_teachers_views.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/ekskul/advisor.dart';
import '../../../domain/entities/ekskul/member.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/usecases/ekskul/create_ekskul.dart';
import '../../auth/widgets/button_role.dart';
import '../../home/views/home_view_admin.dart';

class AddDataEkskulView extends StatefulWidget {
  const AddDataEkskulView({super.key});

  @override
  State<AddDataEkskulView> createState() => _AddDataEkskulViewState();
}

class _AddDataEkskulViewState extends State<AddDataEkskulView> {
  final TextEditingController _namaEkskulC = TextEditingController();
  final TextEditingController _namePembinaC = TextEditingController();
  final TextEditingController _nameKetuaC = TextEditingController();
  final TextEditingController _nameWakilC = TextEditingController();
  final TextEditingController _nameSekretarisC = TextEditingController();
  final TextEditingController _nameBendaharaC = TextEditingController();
  final TextEditingController _deskripsiC = TextEditingController();

  AdvisorEntity? _selectedPembina;
  List<MemberEntity>? members;

  @override
  void dispose() {
    super.dispose();
    _namaEkskulC.dispose();
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

    List<TextEditingController> listC = [
      _namaEkskulC,
      _namePembinaC,
      _nameKetuaC,
      _nameWakilC,
      _nameSekretarisC,
      _nameBendaharaC,
      _deskripsiC,
    ];
    List<String> hintText = [
      'Nama Ekstrakulikuler:',
      'Nama Pembina:',
      'Nama Ketua',
      'Nama Wakil Ketua',
      'Nama Sekretaris',
      'Nama Bendahara',
      'Deskripsi:'
    ];
    List<int> maxLines = [
      1,
      1,
      1,
      1,
      1,
      1,
      5,
    ];
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
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
                const BasicAppbar(isBackViewed: true, isProfileViewed: false),
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
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      if (index == 0 || index == 6) {
                        return TextField(
                          controller: listC[index],
                          maxLines: maxLines[index],
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: hintText[index],
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                      return TextField(
                        readOnly: true,
                        controller: listC[index],
                        maxLines: maxLines[index],
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
                          final route = (index == 1)
                              ? MaterialPageRoute(
                                  builder: (_) => const SearchTeachersViews())
                              : MaterialPageRoute(
                                  builder: (_) => const SearchStudentsView());

                          final result = await Navigator.push(context, route);

                          if (result != null) {
                            setState(() {
                              if (index == 1 && result is TeacherEntity) {
                                _selectedPembina = AdvisorEntity(
                                  id: result.id,
                                  status: "Aktif",
                                );
                                _namePembinaC.text = result.name ?? '';
                              } else if (result is StudentEntity) {
                                members ??= [];
                                String role = "";
                                TextEditingController? targetController;

                                switch (index) {
                                  case 2:
                                    role = "Ketua";
                                    targetController = _nameKetuaC;
                                    break;
                                  case 3:
                                    role = "Wakil Ketua";
                                    targetController = _nameWakilC;
                                    break;
                                  case 4:
                                    role = "Sekretaris";
                                    targetController = _nameSekretarisC;
                                    break;
                                  case 5:
                                    role = "Bendahara";
                                    targetController = _nameBendaharaC;
                                    break;
                                }
                                if (role.isNotEmpty) {
                                  members!.add(MemberEntity(
                                    id: result.id,
                                    role: role,
                                  ));
                                  targetController?.text = result.name ?? '';
                                }
                              }
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
                ),
                Builder(builder: (context) {
                  return ButtonRole(
                    onPressed: () {
                      if (_namaEkskulC.text.isEmpty ||
                          _selectedPembina == null ||
                          members == null ||
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
                                advisor: _selectedPembina,
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
