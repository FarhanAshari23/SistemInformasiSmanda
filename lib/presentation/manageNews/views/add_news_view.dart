import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/views/ack_news_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageNews/widgets/field_news.dart';

import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';

class AddNewsView extends StatefulWidget {
  const AddNewsView({super.key});

  @override
  State<AddNewsView> createState() => _AddNewsViewState();
}

class _AddNewsViewState extends State<AddNewsView> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _fromC = TextEditingController();
  final TextEditingController _contentC = TextEditingController();
  final TextEditingController _toC = TextEditingController();

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
    Timestamp now = Timestamp.now();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            const Text(
              'BUAT PENGUMUMAN',
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
            BasicButton(
              onPressed: () {
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
                  FocusScope.of(context).unfocus();
                  AppNavigator.push(
                    context,
                    AckNewsView(
                      createNewsReq: NewsModel(
                        title: _titleC.text,
                        content: _contentC.text,
                        from: _fromC.text,
                        to: _toC.text,
                        createdAt: now,
                      ),
                    ),
                  );
                }
              },
              title: 'Lanjut',
            )
          ],
        ),
      ),
    );
  }
}
