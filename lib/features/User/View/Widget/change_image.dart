import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/resource/styles.dart';
import '../../ViewModel/user_cubit.dart';

import '../../../../core/utils/resource/string.dart';

class ChangeImage extends StatelessWidget {
  const ChangeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(AppStrings.user.changeImage, style: Styles.text16()),
          ),
        ),
        Divider(
          height: 5.h,
          indent: 15,
          endIndent: 15,
        ),
        _items(
          context,
          text: AppStrings.user.takePicture,
          onTap: () => context.read<UserCubit>().pickFromCamera(),
        ),
        _items(
          context,
          text: AppStrings.user.importFromGallery,
          onTap: () => context.read<UserCubit>().pickFromGallery(),
        ),
        _items(
          context,
          text: AppStrings.user.importFromGoogleDrive,
          onTap: () => context.read<UserCubit>().pickFromFile(),
        ),
      ],
    );
  }

  Widget _items(
    BuildContext context, {
    required void Function() onTap,
    required String text,
  }) =>
      TextButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).r,
          child: Text(
            text,
            style: Styles.text16(),
          ),
        ),
      );
}
