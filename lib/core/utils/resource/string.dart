class AppStrings {
  static const String indexNamePage = "Index";
  static const String calenderNamePage = "Calender";
  static const String addNamePage = "  ";
  static const String focusNamePage = "Focus";
  static const String todayTask = "Today";
  static const String completeTask = "Complete";
  static const String cancel = "Cancel";
  static const String chooseTime = "Choose Time";
  static const String chooseDate = "Choose Date";
  static const String edite = "Edite";
  static const String addTask = "Add Task";
  static const String title = "Add Task";
  static const String description = "Description";

  // User Screen
  static const String profileNamePage = "Profile";
  static User user = User();
}

class User {
  String taskLeft = "Task left";
  String taskDone = "Task done" ;
  String changePassword = "Change account Password";
  String changeImage = "Change Image";
  String changeName = "Change account name";
  String takePicture = "Tack picture";
  String importFromGallery = "Import from gallery";
  String importFromGoogleDrive = "Import from Google Drive";
  String oldPassword = "Old Password";
  String newPassword = "New Password";

  String logOut = "Log Out";
  String messageForSameName = 'The same name already exists';
  String messageWrongPassword = "The old Password is not Right";
}
