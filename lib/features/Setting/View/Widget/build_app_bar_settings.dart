import 'package:flutter/material.dart';

import '../../../../core/utils/resource/icons.dart';

class BuildAppBarSettings extends StatelessWidget
    implements PreferredSizeWidget {
  const BuildAppBarSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.only(left: 24,top: 15),
          child: AppIcons.arrowBack,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
