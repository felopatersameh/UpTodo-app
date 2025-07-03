import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int _colorIcon;

  @HiveField(2)
  final int _backGroundColor;

  CategoryModel({
    required this.name,
     IconData ?iconData,
    required int colorIcon,
    required int backGroundColor,
  })
  // :  iconDataString = iconData.codePoint.toString(),
  : _colorIcon = colorIcon ,
        _backGroundColor = backGroundColor ;

  Color get colorIcon => Color(_colorIcon);

  Color get backGroundColor => Color(_backGroundColor);

  // Convert String back to IconData for usage
  // IconData get iconData =>
  //     IconData(int.parse(iconDataString), fontFamily: 'MaterialIcons');

// Retrieve IconData directly from the model
  IconData get iconData => _iconMapping[name] ?? Icons.help_outline;

// Static mapping for all icons (hidden from external classes)
// @HiveField(3)
  static Map<String, IconData> get _iconMapping => {
        "Grocery": Icons.cake_outlined,
        "Work": Icons.work_outline_rounded,
        "Sport": Icons.fitness_center,
        "Design": Icons.design_services,
        "University": Icons.school_outlined,
        "Social": Icons.campaign_outlined,
        "Music": Icons.music_note_outlined,
        "Health": Icons.health_and_safety_outlined,
        "Movie": Icons.videocam_outlined,
        "Home": Icons.home,
        // for (final iconMapping in defaultCategory)
        //   {iconMapping.name: iconMapping.icon}
      };

}
