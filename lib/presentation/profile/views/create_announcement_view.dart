import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/landing/succes.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/news/news.dart';
import '../../../domain/usecases/news/create_news.dart';
import '../../auth/widgets/button_role.dart';
import '../../admin/news/views/select_kelas_view.dart';
import '../../admin/news/widgets/field_news.dart';
import 'profile_teacher_view.dart';

class CreateAnnouncementView extends StatefulWidget {
  final int teacherId;
  const CreateAnnouncementView({
    super.key,
    required this.teacherId,
  });

  @override
  State<CreateAnnouncementView> createState() => _CreateAnnouncementViewState();
}

class _CreateAnnouncementViewState extends State<CreateAnnouncementView> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _contentC = TextEditingController();
  final TextEditingController _toC = TextEditingController();
  List<int> classid = [];

  @override
  void dispose() {
    _titleC.dispose();
    _contentC.dispose();
    _toC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) => GetAllKelasCubit()..displayAll(),
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
            AppNavigator.push(
              context,
              SuccesPage(
                page: ProfileTeacher(teacherId: widget.teacherId),
                title: "Data Pengumuman Berhasil Ditambahkan",
              ),
            );
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(isBackViewed: true),
                const Text(
                  'BUAT PENGUMUMAN',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: height * 0.05),
                BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
                  builder: (context, state) {
                    if (state is KelasDisplayLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is KelasDisplayLoaded) {
                      return Expanded(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldNews(
                                  title: 'Masukkan Judul Pengumuman',
                                  controller: _titleC,
                                  hinttext: 'Judul Pengumuman...',
                                  line: 2,
                                ),
                                SizedBox(height: height * 0.02),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Untuk Siapa Pengumuman ini?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    TextField(
                                      controller: _toC,
                                      maxLines: 2,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        hintText: "Untuk siapa..",
                                      ),
                                      onTap: () async {
                                        List<KelasEntity>? result =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SelectKelasView(
                                                    classes: state.kelas),
                                          ),
                                        );
                                        if (result != null) {
                                          List<String> name = [];
                                          for (var i = 0;
                                              i < result.length;
                                              i++) {
                                            name.add(result[i].className ?? '');
                                            classid.add(result[i].id!);
                                          }
                                          _toC.text = classid.length ==
                                                  state.kelas.length
                                              ? "Semua Kelas"
                                              : name.join(", ");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.02),
                                FieldNews(
                                  title: 'Masukkan Isi Pengumuman',
                                  controller: _contentC,
                                  hinttext: 'Isi Pengumuman...',
                                  line: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
                  builder: (context, state) {
                    if (state is KelasDisplayLoaded) {
                      return ButtonRole(
                        onPressed: () {
                          if (_titleC.text.isEmpty ||
                              _contentC.text.isEmpty ||
                              _toC.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Tolong Isi Semua Kolom yang Sudah Disediakan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            bool isGlobal = classid.length == state.kelas.length
                                ? true
                                : false;
                            FocusScope.of(context).unfocus();
                            context.read<ButtonStateCubit>().execute(
                                  usecase: CreateNewsUseCase(),
                                  params: NewsEntity(
                                    title: _titleC.text,
                                    description: _contentC.text,
                                    classId: classid,
                                    isGlobal: isGlobal,
                                    teacherId: widget.teacherId,
                                  ),
                                );
                          }
                        },
                        title: 'Simpan',
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
