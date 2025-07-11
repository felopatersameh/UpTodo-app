
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uptodo/core/utils/Notifications/custom_notification_manager.dart';
import '../../../../core/utils/resource/constant.dart';
import '../../../../core/utils/resource/messages.dart';
import '../../../../core/utils/resource/icons.dart';

import '../../../../core/utils/Widget/build_text_form_field.dart';
import '../../../../core/utils/resource/colors.dart';
import '../../../../core/utils/resource/string.dart';
import '../../../../core/utils/resource/styles.dart';
import '../../ViewModel/AddTask/add_task_cubit.dart';
import '../../../task/ViewModel/UpdateTask/update_task_cubit.dart';
import 'build_category.dart';
import 'build_priority.dart';
import 'calendar_picker.dart';
import 'time_picker.dart';
import '../../model/category_model.dart';
import '../../model/priority_model.dart';
import '../../../../core/model/task_model.dart';
import '../../../../core/utils/Widget/custom_messages.dart';

class DialogAddTask extends StatefulWidget {
  final TaskModel? taskModel;

  const DialogAddTask({
    super.key,
    this.taskModel,
  });

  @override
  State<DialogAddTask> createState() => _DialogAddTaskState();
}

final TextEditingController _title = TextEditingController();
final TextEditingController _description = TextEditingController();
final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
DateTime? _data;
CategoryModel? _categoryModel;
PriorityModel? _priorityModel;

class _DialogAddTaskState extends State<DialogAddTask> {
  @override
  void initState() {
    if (widget.taskModel != null) {
      _title.text = widget.taskModel!.title;
      _description.text = widget.taskModel!.description;
      _data = widget.taskModel!.dateTime;
      _categoryModel = widget.taskModel!.type;
      _priorityModel = widget.taskModel!.priority;
    } else {
      _title.clear();
      _description.clear();
      _data = null;
      _categoryModel = null;
      _priorityModel = null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: ListView(
        reverse: true,
        shrinkWrap: true,
        physics: AppConstant.physics,
        children: [
          Form(
            key: _keyForm,
            child: Container(
              color: AppColors.secondBackGroundColor,
              height: 300.h,
              width: 1.sw,
              padding: const EdgeInsets.all(25.0).r,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0).r,
                    child: Text(
                      AppStrings.addTask,
                      style: Styles.text20AppBar(),
                    ),
                  ),
                  10.verticalSpace,
                  BuildTextFormField(
                    controller: _title,
                    hint: AppStrings.title,
                    // focusNode: _titleFocusNode,
                  ),
                  18.verticalSpace,
                  BuildTextFormField(
                    controller: _description,
                    hint: AppStrings.description,
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 19).r,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => _showCalendarPicker(context),
                                  icon: Icon(
                                    _data == null
                                        ? AppIcons.timerOutlined
                                        : AppIcons.timerRounded,
                                    color: AppColors.iconColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _buildCategory(context),
                                  icon: Icon(
                                    _categoryModel == null
                                        ? AppIcons.sellOutlined
                                        : AppIcons.sellRounded,
                                    color: AppColors.iconColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _buildPriority(context),
                                  icon: Icon(
                                    _priorityModel == null
                                        ? AppIcons.flagOutlined
                                        : AppIcons.flagRounded,
                                    color: AppColors.iconColor,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => _onPressed(),
                              icon: AppIcons.send,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() async {
    if (_keyForm.currentState?.validate() == true) {
      if (_data == null) {
        showMessage(
          text: AppMessages.customMessage("Date&&Time"),
          state: ToastStates.error,
        );
      } else if (_categoryModel == null) {
        showMessage(
          text: AppMessages.customMessage("category"),
          state: ToastStates.error,
        );
      } else if (_priorityModel == null) {
        showMessage(
          text: AppMessages.customMessage("priority"),
          state: ToastStates.error,
        );
      } else {
        final task = TaskModel(
          id: widget.taskModel?.id,
          title: _title.text,
          dateTime: _data!,
          type: _categoryModel!,
          priority: _priorityModel!,
          description: _description.text,
        );
        // =null=> is not found => [add]
        if (widget.taskModel == null) {
          context.read<AddTaskCubit>().addTask(task, context);
          showMessage(text: AppMessages.addTask, state: ToastStates.succeed);
          await NotificationManager().scheduleSingleNotification(
            id: task.idNotification,
            title: task.title,
            body: task.description,
            scheduledTime: task.dateTime,
            payload: task.id,
          );
          clearData();
        }
        // != null => is found => [update]
        else {
          if (task != widget.taskModel) {
            // context.read<AddTaskCubit>().addTask(task, context);
            context.read<UpdateTaskCubit>().update(task, context);
            showMessage(
                text: AppMessages.updateTask, state: ToastStates.succeed);
            await NotificationManager().cancelNotification(task.idNotification);
          }
          await NotificationManager().scheduleSingleNotification(
            id: task.idNotification,
            title: task.title,
            body: task.description,
            scheduledTime: task.dateTime,
            payload: task.id,
          );
          clearData();
        }
      }
    }
  }

  Future<void> _showCalendarPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (p0) => BuildCalendarPicker(
        dateTime: _data ?? widget.taskModel?.dateTime,
      ),
    ).then((date) {
      if (date != null && mounted) {
        _data = date;
        _showTimePicker(context);
      }
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => BuildTimePicker(
        dateTime: _data ?? widget.taskModel?.dateTime,
      ),
    ).then((date) {
      if (date != null) {
        final hour = date[0];
        final minute = date[1];
        _data = _data!.copyWith(hour: hour, minute: minute);
      }
    });
  }

  Future<dynamic> _buildCategory(BuildContext context) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => BuildCategory(),
    ).then((p0) {
      if (p0 != null) {
        _categoryModel = p0;
      }
    });
  }

  Future<dynamic> _buildPriority(BuildContext context) {
    return showDialog(context: context, builder: (context) => BuildPriority())
        .then((priority) {
      if (priority != null) {
        _priorityModel = priority;
      }
    });
  }

  void clearData() {
    _title.clear();
    _description.clear();
    _data = null;
    _categoryModel = null;
    _priorityModel = null;
    Navigator.of(context).pop();
  }
}

//******************************************************
