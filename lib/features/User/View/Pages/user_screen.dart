import 'package:flutter/material.dart';
import 'package:uptodo/core/utils/resource/constant.dart';
import '../../../../core/utils/resource/string.dart';

import '../Widget/box_items.dart';

import '../Widget/user_details.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileNamePage),
      ),
      body: SingleChildScrollView(
        physics: AppConstant.physics,
        child: Column(
          children: [
            const UserDetails(),
            BoxOFListProfileItems(),
            // const LogOut()
          ],
        ),
      ),
    );
  }
}
