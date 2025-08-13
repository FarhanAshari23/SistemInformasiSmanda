import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/email_check.dart';
import 'package:new_sistem_informasi_smanda/common/widget/appbar/basic_appbar.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/core/configs/theme/app_colors.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/bloc/password_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/add_account_detail_view.dart';

class AddStudentView extends StatelessWidget {
  AddStudentView({super.key});

  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => PasswordCubit(),
        child: SafeArea(
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
                    SizedBox(height: height * 0.03),
                    BlocBuilder<PasswordCubit, bool>(
                      builder: (context, state) {
                        return TextField(
                          obscureText: state,
                          controller: _passC,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'password:',
                            suffixIcon: IconButton(
                              onPressed: () {
                                context
                                    .read<PasswordCubit>()
                                    .togglePasswordVisibility();
                              },
                              icon: Icon(
                                state ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        );
                      },
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
                  }
                  if (!checkEmail(_emailC.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Format email salah, masukkan email dengan benar',
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
      ),
    );
  }
}
