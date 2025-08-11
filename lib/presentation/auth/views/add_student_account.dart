import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/add_student_detail_view.dart';

class AddStudentView extends StatelessWidget {
  AddStudentView({super.key});

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const BasicAppbar(
              isBackViewed: true,
              isProfileViewed: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text(
                    'Buat akun siswa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextField(
                    controller: _emailC,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'email:',
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '*Format email adalah duanamabelakangnisn@smanda.com',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  TextField(
                    controller: _passC,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'password:',
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '*Format password adalah NIPD_NAMADEPAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.1),
                ],
              ),
            ),
            const Spacer(),
            BasicButton(
              onPressed: () {
                if (_emailC.text.isEmpty || _passC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Tolong isi kolom email dan password yang telah tersedia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  AppNavigator.push(
                    context,
                    AddStudentDetailView(
                      userCreationReq: UserCreationReq(
                        email: _emailC.text,
                        password: _passC.text,
                      ),
                    ),
                  );
                }
              },
              title: 'Lanjut',
            ),
          ],
        ),
      ),
    );
  }
}
