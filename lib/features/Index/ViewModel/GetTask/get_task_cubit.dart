import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/Notifications/custom_notification_manager.dart';
import '../../../../core/model/task_model.dart';

import '../../../../core/Network/serves_locator.dart';
import '../../../../core/utils/resource/format.dart';

part 'get_task_state.dart';

class GetTaskCubit extends Cubit<GetTaskState> {
  GetTaskCubit() : super(GetTaskInitial());
  List<TaskModel> taskModel = [];
  List<TaskModel> filteredTasks = [];
  DateTime dateTime = DateTime.now();
  DateTime selectedDateTime = DateTime.now();
  int doneTask = 0;
  int selected = 0;
  bool isSearching = false;

  void getAllTasks() {
    final box = getIt<Box<TaskModel>>();
    if (taskModel.isNotEmpty) {
      taskModel = [];
    }

    taskModel.addAll(box.values);

    doneTask = getCompletedTaskCount();
    getIndexTaskRunningToday();
    getIndexTaskCompletedToday();
    emit(GetAllTasksSucceed());
  }

  List<TaskModel> getIndexTaskRunningToday() {
    final String dateTimeFormat =
        DateFormat(AppFormat.formatDateTask).format(dateTime);
    final listRunning = taskModel.where(
      (element) {
        return DateFormat(AppFormat.formatDateTask).format(element.dateTime) ==
                dateTimeFormat &&
            element.isCompleted == false;
      },
    ).toList();
    return listRunning;
  }

  List<TaskModel> getIndexTaskCompletedToday() {
    final String dateTimeFormat =
        DateFormat(AppFormat.formatDateTask).format(dateTime);
    final listCompleted = taskModel.where(
      (element) {
        if (DateFormat(AppFormat.formatDateTask).format(element.dateTime) ==
                dateTimeFormat &&
            element.isCompleted) {
          return true;
        } else {
          return false;
        }
      },
    ).toList();
    doneTask = getCompletedTaskCount();
    return listCompleted;
  }

  //--------------------------------------------------
  List<TaskModel> selectTaskCompletedBySelectedDateTime() {
    final String dateTimeFormat =
        DateFormat(AppFormat.formatDateTask).format(selectedDateTime);
    final listCompleted = taskModel.where(
      (element) {
        if (DateFormat(AppFormat.formatDateTask).format(element.dateTime) ==
                dateTimeFormat &&
            element.isCompleted) {
          // taskIsCompleted.add(element);
          return true;
        } else {
          return false;
        }
      },
    ).toList();
    doneTask = getCompletedTaskCount();
    return listCompleted;
  }

  List<TaskModel> selectTaskRunningBySelectedDateTime() {
    // taskIsRunning = [];
    final String dateTimeFormat =
        DateFormat(AppFormat.formatDateTask).format(selectedDateTime);
    log(dateTimeFormat);
    final listRunning = taskModel.where(
      (element) {
        log(element.dateTime.toString());
        return DateFormat(AppFormat.formatDateTask).format(element.dateTime) ==
                dateTimeFormat &&
            element.isCompleted == false;
      },
    ).toList();

    return listRunning;
  }

  void changeDate(DateTime currentDateTime) {
    selectedDateTime = currentDateTime;

    selectTaskCompletedBySelectedDateTime();
    selectTaskRunningBySelectedDateTime();
    emit(ChangeDate());
  }

  int getCompletedTaskCount() {
    final completedTasks = taskModel.where((task) => task.isCompleted).toList();
    return completedTasks.length;
  }

  void update(TaskModel updatedTask) {
    final box = getIt<Box<TaskModel>>();

    final taskKey = box.keys.firstWhere(
      (key) => box.get(key)?.id == updatedTask.id,
      orElse: () => null,
    );

    if (taskKey != null) {
      box.put(taskKey, updatedTask);
    }
  }

  void deleteTask(BuildContext context, String taskId) {
    final box = getIt<Box<TaskModel>>();

    final taskKey = box.keys.firstWhere(
      (key) {
        final value = box.get(key)?.id == taskId;
        if (value && DateTime.now().isBefore(box.get(key)!.dateTime)) {
          NotificationManager()
              .cancelNotification(box.get(key)!.idNotification);
        }
        return value;
      },
      orElse: () => null,
    );

    if (taskKey != null) {
      box.delete(taskKey);
    }

    getAllTasks();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task deleted successfully")),
    );
  }

  // Search tasks by title
  void searchTasksByTitle(String query) {
    if (query.isEmpty) {
      isSearching = false;
      filteredTasks = taskModel;
    } else {
      isSearching = true;
      filteredTasks = taskModel
          .where((task) =>
          task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(SearchTasksSucceed());
  }

}
