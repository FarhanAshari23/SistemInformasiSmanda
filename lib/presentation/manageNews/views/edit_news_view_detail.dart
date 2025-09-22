import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/news_cubit.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../common/widget/button/basic_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/news/news.dart';
import '../../../domain/usecases/news/update_news.dart';
import '../../../service_locator.dart';
import '../widgets/field_news.dart';

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

  @override
  void initState() {
    _titleC = TextEditingController(text: widget.news.title);
    _fromC = TextEditingController(text: widget.news.from);
    _contentC = TextEditingController(text: widget.news.content);
    _toC = TextEditingController(text: widget.news.to);
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
      body: SafeArea(
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
            Expanded(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.45,
                            child: FieldNews(
                              title: 'Untuk Siapa Pengumuman Ini?',
                              controller: _toC,
                              hinttext: 'Untuk Siapa...',
                              line: 2,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.45,
                            child: FieldNews(
                              title: 'Dari Siapa Pengumuman Ini?',
                              controller: _fromC,
                              hinttext: 'Dari Siapa...',
                              line: 2,
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
            ),
            SizedBox(height: height * 0.04),
            BasicButton(
              onPressed: () async {
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
                  var result = await sl<UpdateNewsUsecase>().call(
                    params: NewsEntity(
                      title: _titleC.text,
                      content: _contentC.text,
                      from: _fromC.text,
                      to: _toC.text,
                    ),
                  );
                  result.fold(
                    (error) {
                      var snackbar = const SnackBar(
                        content: Text("Gagal Mengubah Data"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    },
                    (r) {
                      context.read<NewsCubit>().displayNews();
                      var snackbar = const SnackBar(
                        content: Text("Data Berhasil Diubah"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.pop(context);
                    },
                  );
                }
              },
              title: 'Ubah',
            )
          ],
        ),
      ),
    );
  }
}
