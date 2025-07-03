import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uptodo/core/model/task_model.dart';

import '../../../../core/utils/resource/format.dart';
import 'build_details_task_view.dart';
import 'delete_task.dart';
import 'task_name_and_description.dart';

class BuildBodyViewTask extends StatelessWidget {
  final TaskModel model;
  const BuildBodyViewTask({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 24, left: 24),
      child: Column(
        children: [
          TaskNameAndDescription(model: model),
          BuildDetailsTaskView(
            value: DateFormat(AppFormat.formatDayTask).format(model.dateTime),
            title: "Task Time :",
            icons: Icons.timer,
          ),
          BuildDetailsTaskView(
            iconsValue: Icon(
              // CategoryHelper.getIconByName(model.type.name),
              model.type.iconData,
              color: model.type.colorIcon,
            ),
            value: model.type.name,
            title: "Task Category :",
            icons: Icons.tag_rounded,
          ),
          BuildDetailsTaskView(
            value: model.priority.number.toString(),
            title: "Task Priority :",
            icons: model.priority.flag,
          ),
          BuildDetailsTaskView(
            value: "Add Sub - Task",
            title: "Sub - Task",
            icons: Icons.history_edu_rounded,
          ),
          DeleteTask(id: model.id)
        ],
      ),
    );
  }
}
