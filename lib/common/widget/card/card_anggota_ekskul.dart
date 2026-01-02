import 'package:flutter/material.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/common/widget/photo/network_photo.dart';
import 'package:new_sistem_informasi_smanda/presentation/students/views/murid_detail.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/views/teacher_detail.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/entities/auth/user.dart';
import '../../helper/cache_state_image.dart';

class CardAnggotaEkskul extends StatefulWidget {
  final UserEntity? murid;
  final TeacherEntity? pembina;
  final String jabatan;
  const CardAnggotaEkskul({
    super.key,
    this.murid,
    this.pembina,
    required this.jabatan,
  });

  @override
  State<CardAnggotaEkskul> createState() => _CardAnggotaEkskulState();
}

class _CardAnggotaEkskulState extends State<CardAnggotaEkskul> {
  late String imageUrl;
  bool? isReachable;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.murid != null
        ? DisplayImage.displayImageStudent(
            widget.murid?.nama ?? '', widget.murid?.nisn ?? '')
        : DisplayImage.displayImageTeacher(
            widget.pembina?.nama ?? '',
            widget.pembina?.nip != '-'
                ? widget.pembina?.nip ?? ''
                : widget.pembina?.tanggalLahir ?? '');
    _checkUrl();
  }

  Future<void> _checkUrl() async {
    final reachable = await CacheStateImage.checkUrl(imageUrl);
    if (mounted) {
      setState(() {
        isReachable = reachable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String fallbackAsset = widget.murid != null
        ? widget.murid!.gender == 1
            ? AppImages.boyStudent
            : widget.murid!.agama == "Islam"
                ? AppImages.girlStudent
                : AppImages.girlNonStudent
        : widget.pembina!.gender == 1
            ? AppImages.guruLaki
            : AppImages.guruPerempuan;
    Widget imageWidget;

    if (isReachable == null) {
      imageWidget = Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: height * 0.1,
          height: height * 0.1,
          color: Colors.grey,
        ),
      );
    } else if (isReachable == true) {
      imageWidget = NetworkPhoto(
        width: height * 0.1,
        height: height * 0.1,
        fallbackAsset: fallbackAsset,
        imageUrl: imageUrl,
      );
    } else {
      imageWidget = Image.asset(
        fallbackAsset,
        width: height * 0.1,
        height: height * 0.1,
        fit: BoxFit.cover,
      );
    }
    return Column(
      children: [
        CustomInkWell(
          borderRadius: 16,
          defaultColor: AppColors.secondary,
          onTap: () {
            if (widget.pembina != null) {
              AppNavigator.push(
                  context, TeacherDetail(teachers: widget.pembina!));
            } else {
              AppNavigator.push(context, MuridDetail(user: widget.murid!));
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            width: height * 0.125,
            height: height * 0.125,
            child: Center(
              child: imageWidget,
            ),
          ),
        ),
        SizedBox(height: height * 0.01),
        Text(
          widget.pembina != null
              ? widget.pembina?.nama ?? ''
              : widget.murid?.nama ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: height * 0.005),
        Text(
          widget.jabatan,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
