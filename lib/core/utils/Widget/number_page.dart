import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'custom_row.dart';
import '../resource/colors.dart';
import '../resource/string.dart';
import '../resource/styles.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key, this.dateTime});

  final DateTime? dateTime;

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  var hour = 0;
  var minute = 0;
  var timeFormat = "AM";

  @override
  void initState() {
    super.initState();
    if (widget.dateTime != null) {
      hour = widget.dateTime!.hour;
      minute = widget.dateTime!.minute;
      if (hour >= 12) {
        timeFormat = "PM";
        if (hour > 12) {
          hour -= 12;
        }
      } else {
        timeFormat = "AM";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondBackGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(AppStrings.chooseTime, style: Styles.text16()),
          ),
          Divider(
            height: 5,
            indent: 15,
            endIndent: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: AppColors.calenderItemBackGroundColor,
                      margin: EdgeInsets.only(right: 13),
                      child: NumberPicker(
                        minValue: 0,
                        maxValue: 12,
                        value: hour,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 64.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            hour = value;
                          });
                        },
                        textStyle: Styles.text16()
                            .copyWith(color: AppColors.gray1TextColor),
                        selectedTextStyle: Styles.text24(),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                color: Colors.white,
                              ),
                              bottom: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    Text(
                      ":",
                      style: Styles.text20AppBar(),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 13, left: 13),
                      color: AppColors.calenderItemBackGroundColor,
                      child: NumberPicker(
                        minValue: 0,
                        maxValue: 59,
                        value: minute,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: 64.w,
                        itemHeight: 40.h,
                        onChanged: (value) {
                          setState(() {
                            minute = value;
                          });
                        },
                        textStyle: Styles.text16()
                            .copyWith(color: AppColors.gray1TextColor),
                        selectedTextStyle: Styles.text24(),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                color: Colors.white,
                              ),
                              bottom: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                timeFormat = "AM";
                              });
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 14),
                              decoration: BoxDecoration(
                                  color: timeFormat == "AM"
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade700,
                                  border: Border.all(
                                    color: timeFormat == "AM"
                                        ? Colors.grey
                                        : Colors.grey.shade700,
                                  )),
                              child: Text(
                                "AM",
                                textAlign: TextAlign.center,
                                style: Styles.text16(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                timeFormat = "PM";
                              });
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 14),
                              decoration: BoxDecoration(
                                color: timeFormat == "PM"
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade700,
                                border: Border.all(
                                  color: timeFormat == "PM"
                                      ? Colors.grey
                                      : Colors.grey.shade700,
                                ),
                              ),
                              child: Text(
                                "PM",
                                textAlign: TextAlign.center,
                                style: Styles.text16(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomRow(
              name: AppStrings.chooseTime,
              onTap: () {
                if (timeFormat == "AM") {
                  if (hour == 12) {
                    hour = 0;
                  }
                } else if (timeFormat == "PM") {
                  if (hour != 12) {
                    hour += 12;
                  }
                }
                Navigator.pop(
                  context,
                  [hour, minute],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
