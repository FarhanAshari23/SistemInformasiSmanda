import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/bloc/kelas/get_all_kelas_cubit.dart';
import '../../../common/bloc/kelas/kelas_display_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/kelas/kelas.dart';
import '../../../domain/entities/news/news.dart';
import '../../../domain/entities/teacher/teacher_golang.dart';
import '../../../domain/usecases/news/update_news.dart';
import '../../auth/widgets/button_role.dart';
import '../widgets/field_news.dart';
import 'select_kelas_view.dart';
import 'select_teacher_view.dart';

class EditNewsViewDetail extends StatefulWidget {
  final NewsEntity news;
  const EditNewsViewDetail({
    super.key,
    required this.news,
  });

  @override
  State<EditNewsViewDetail> createState() => _EditNewsViewDetailState();
}

class _EditNewsViewDetailState extends State<EditNewsViewDetail> {
  late TextEditingController _titleC;
  late TextEditingController _fromC;
  late TextEditingController _contentC;
  late TextEditingController _toC;
  late List<int> classid;
  late int teacherId;

  @override
  void initState() {
    _titleC = TextEditingController(text: widget.news.title);
    _fromC = TextEditingController(text: widget.news.teacherName);
    _contentC = TextEditingController(text: widget.news.description);
    _toC = TextEditingController(
        text: widget.news.isGlobal! ? "Semua Kelas" : widget.news.className!);
    classid = widget.news.classIds!;
    teacherId = widget.news.teacherId!;
    super.initState();
  }

  @override
  void dispose() {
    _titleC.dispose();
    _fromC.dispose();
    _contentC.dispose();
    _toC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: MultiBlocProvider(
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
              var snackbar = const SnackBar(
                content: Text("Data pengumuman berhasil diubah"),
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
                  'EDIT PENGUMUMAN',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.45,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                classid.clear();
                                                for (var i = 0;
                                                    i < result.length;
                                                    i++) {
                                                  name.add(result[i].className);
                                                  classid.add(result[i].id!);
                                                }
                                                _toC.text = name.join(", ");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.45,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Dari Siapa Pengumuman ini?",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          TextField(
                                            controller: _fromC,
                                            maxLines: 2,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                              hintText: "Dari siapa..",
                                            ),
                                            onTap: () async {
                                              TeacherGolangEntity result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SelectTeacherView(),
                                                ),
                                              );
                                              teacherId = result.id ?? 0;
                                              _fromC.text = result.name ?? '';
                                            },
                                          ),
                                        ],
                                      ),
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
                SizedBox(height: height * 0.04),
                BlocBuilder<GetAllKelasCubit, KelasDisplayState>(
                  builder: (context, state) {
                    if (state is KelasDisplayLoaded) {
                      return ButtonRole(
                        onPressed: () {
                          print("DEBUG UI - Teacher ID: ${teacherId}");
                          print("DEBUG UI - Class IDs: ${classid}");
                          if (_titleC.text.isEmpty ||
                              _contentC.text.isEmpty ||
                              _fromC.text.isEmpty ||
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
                                  usecase: UpdateNewsUsecase(),
                                  params: NewsEntity(
                                    newsId: widget.news.newsId,
                                    title: _titleC.text,
                                    description: _contentC.text,
                                    classId: classid,
                                    isGlobal: isGlobal,
                                    teacherId: teacherId,
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
