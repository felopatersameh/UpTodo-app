import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import '../../../../core/Network/serves_locator.dart';
import '../../../../core/utils/Widget/build_text_form_field.dart';
import '../../../../core/utils/Widget/custom_messages.dart';
import '../../../../core/utils/Widget/custom_row.dart';
import '../../../../core/utils/resource/string.dart';
import '../../../../core/utils/resource/styles.dart';

class ChangeTimeRemember extends StatefulWidget {
  const ChangeTimeRemember({super.key});

  @override
  State<ChangeTimeRemember> createState() => _ChangeTimeRememberState();
}

final TextEditingController name = TextEditingController();
final GlobalKey<FormState> keyForm = GlobalKey<FormState>();

class _ChangeTimeRememberState extends State<ChangeTimeRemember> {
  int? notificationTimeReminder;

  @override
  void initState() {
    notificationTimeReminder = getIt.get<Box<double>>().get('notificationTimeReminder', defaultValue: 15)?.toInt();
    name.text = notificationTimeReminder.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).r,
            child: Text(AppStrings.user.changeName, style: Styles.text16()),
          ),
          Divider(
            height: 5.h,
            indent: 15,
            endIndent: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24).r,
            child: BuildTextFormField(controller: name),
          ), // Spacer(),
          Expanded(
            child: CustomRow(
              name: AppStrings.edite,
              onTap: () {
                if (name.text != notificationTimeReminder!.toString()) {
                  getIt.get<Box<double>>().put('notificationTimeReminder', double.parse(name.text));
                  Navigator.of(context).pop();
                  name.clear();
                  showMessage(
                      text: AppStrings.edite, state: ToastStates.succeed);
                } else if (name.text == notificationTimeReminder!.toString()) {
                }
              },
            ),
          ),
          8.verticalSpace
        ],
      ),
    );
  }
}
