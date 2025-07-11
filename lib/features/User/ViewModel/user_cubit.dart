import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/Widget/custom_messages.dart';
import '../../../core/utils/resource/constant.dart';
import '../../../core/utils/resource/messages.dart';
import '../../../core/Network/serves_locator.dart';
import '../../../core/model/task_model.dart';

import '../Model/user_account_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  File? imageUser;
  File? imageDefault;

  Future<void> copyAssetToLocalImage(
      {String? assetPath, String? fileName}) async {
    final boxUser = getIt<Box<UserAccountModel>>();
    if (boxUser.isEmpty) {
      assetPath ??= 'Assets/Images/olak_cr0o_230714.jpg';
      fileName ??= 'olak_cr0o_230714.jpg';

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      imageDefault = file;
      emit(ImagePickedSuccess(File(file.path)));
    }
  }

  UserAccountModel initUserScreen() {
    final boxUser = getIt<Box<UserAccountModel>>();
    final boxTask = getIt<Box<TaskModel>>();

    if (boxUser.isEmpty) {
      final user = UserAccountModel(
        AppConstant.kName,
        imageDefault!.path,
        AppConstant.kPass,
        boxTask.values.toList(),
      );
      boxUser.add(user);
      return user;
    } else {
      return boxUser.getAt(0)!;
    }
  }

  void updateUser({String? name, String? image, String? password}) {
    final boxUser = getIt<Box<UserAccountModel>>();
    if (boxUser.isNotEmpty) {
      final user = boxUser.getAt(0)!;
      final updatedUser = UserAccountModel(
        name ?? user.name,
        image ?? user.image,
        password ?? user.password,
        user.tasks,
      );
      boxUser.putAt(0, updatedUser);
      showMessage(text: AppMessages.succeed, state: ToastStates.succeed);
      emit(UserUpdated(updatedUser));
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickFromCamera() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageUser = File(pickedFile.path);
      updateUser(image: imageUser!.path);

      emit(ImagePickedSuccess(File(pickedFile.path)));
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageUser = File(pickedFile.path);
      updateUser(image: imageUser!.path);
      emit(ImagePickedSuccess(File(pickedFile.path)));
    }
  }

  Future<void> pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      imageUser = File(result.files.single.path!);
      updateUser(image: imageUser!.path);

      emit(ImagePickedSuccess(File(result.files.single.path!)));
    }
  }
}
