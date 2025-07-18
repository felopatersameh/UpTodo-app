import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


import '../../../../core/utils/resource/icons.dart';
import '../../../../core/utils/resource/string.dart';
import '../../../../core/utils/resource/styles.dart';
import '../../../../core/utils/resource/colors.dart';
import '../../../AddTask/View/Pages/add_task_screen.dart';
import '../../../Calendar/View/Pages/calendar_screen.dart';
import '../../../Focus/focus_screen.dart';
import '../../../Index/View/Pages/index_screen.dart';
import '../../../User/View/Pages/user_screen.dart';

class BuildBottomNavigationBar extends StatefulWidget {
  const BuildBottomNavigationBar({
    super.key,
  });

  @override
  State<BuildBottomNavigationBar> createState() =>
      _BuildBottomNavigationBarState();
}

Color _defaultSelectAndUnSelected = Colors.white;
late PersistentTabController _controller;

class _BuildBottomNavigationBarState extends State<BuildBottomNavigationBar> {
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      const IndexScreen(),
      const CalendarScreen(),
      const Scaffold(),
      const FocusScreen(),
      const UserScreen(),
    ];
  }
  List<PersistentBottomNavBarItem> navBarsItems(BuildContext context) => [
    PersistentBottomNavBarItem(
      icon: AppIcons.indexActivePage,
      inactiveIcon: AppIcons.indexInActivePage,
      textStyle: Styles.text12(),
      title: (AppStrings.indexNamePage),
      activeColorPrimary: _defaultSelectAndUnSelected,
      inactiveColorPrimary: _defaultSelectAndUnSelected,
    ),
    PersistentBottomNavBarItem(
      inactiveIcon: AppIcons.calenderInActivePage,
      title: (AppStrings.calenderNamePage),
      icon: AppIcons.calenderActivePage,
      textStyle: Styles.text12(),
      activeColorPrimary: _defaultSelectAndUnSelected,
      inactiveColorPrimary: _defaultSelectAndUnSelected,
    ),
    PersistentBottomNavBarItem(
      icon: AppIcons.addActiveAndInActivePage,
      title: AppStrings.addNamePage,
      textStyle: Styles.text12(),
      activeColorPrimary: AppColors.primaryColor,
      inactiveColorPrimary: AppColors.primaryColor,
      onPressed: (p0) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const AddTaskScreen(),
        );
      },
    ),
    PersistentBottomNavBarItem(
      inactiveIcon: AppIcons.focusInActivePage,
      icon: AppIcons.focusActivePage,
      title: AppStrings.focusNamePage,
      textStyle: Styles.text12(),
      activeColorPrimary: _defaultSelectAndUnSelected,
      inactiveColorPrimary: _defaultSelectAndUnSelected,
    ),
    PersistentBottomNavBarItem(
      icon: AppIcons.profileActivePage,
      inactiveIcon: AppIcons.profileInActivePage,
      title: AppStrings.profileNamePage,
      textStyle: Styles.text12(),
      activeColorPrimary: _defaultSelectAndUnSelected,
      inactiveColorPrimary: _defaultSelectAndUnSelected,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: navBarsItems(context),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppColors.secondBackGroundColor,
      navBarStyle: NavBarStyle.style15,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardAppears: true,
      handleAndroidBackButtonPress: false,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
    );
  }
}
