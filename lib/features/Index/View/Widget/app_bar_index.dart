import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/resource/colors.dart';
import '../../../../core/utils/resource/string.dart';
import '../../../User/ViewModel/user_cubit.dart';

class BuildAppBarIndex extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  const BuildAppBarIndex({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        margin: EdgeInsets.only(top: 13).r,
        child: Text(
          AppStrings.indexNamePage,
        ),
      ),
      leading: Container(
        margin: EdgeInsets.only(left: 24, top: 13).r,
        child: Icon(
          Icons.sort_rounded,
          color: AppColors.iconColor,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 24, top: 13).r,
          child: context.watch<UserCubit>().initUserScreen().image.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CircleAvatar(
                  backgroundImage: FileImage(
                    File(context.watch<UserCubit>().initUserScreen().image),
                  ),
                  radius: (.05).sw,
                ),
        )
      ],
    );
  }
}
