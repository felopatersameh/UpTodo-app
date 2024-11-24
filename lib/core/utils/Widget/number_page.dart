import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../features/AddTask/ViewModel/TimePicker/time_picker_cubit.dart';
import '../../../features/AddTask/model/time_picker_model.dart';
import 'custom_row.dart';
import '../resource/colors.dart';
import '../resource/string.dart';
import '../resource/styles.dart';

class NumberPage extends StatelessWidget {
  final DateTime? dateTime;

  const NumberPage({super.key, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimePickerCubit(dateTime),
      child: const NumberPageContent(),
    );
  }
}

class NumberPageContent extends StatelessWidget {
  const NumberPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TimePickerCubit>();

    return Container(
      color: AppColors.secondBackGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppStrings.chooseTime,
              style: Styles.text16(),
            ),
          ),
          const Divider(
            height: 5,
            indent: 15,
            endIndent: 15,
          ),

          // Time Pickers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 10),
            child: BlocBuilder<TimePickerCubit, TimePickerState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Hour Picker
                    _buildNumberPicker(
                      value: state.hour,
                      minValue: 1,
                      maxValue: 12,
                      onChanged: cubit.setHour,
                    ),

                    // Separator
                    Text(":", style: Styles.text20AppBar()),

                    // Minute Picker
                    _buildNumberPicker(
                      value: state.minute,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: cubit.setMinute,
                    ),

                    // AM/PM Selector
                    _buildTimeFormatSelector(context, state, cubit),
                  ],
                );
              },
            ),
          ),

          // Bottom Button
          Expanded(
            child: CustomRow(
              name: AppStrings.chooseTime,
              onTap: () {
                final selectedTime = cubit.getFinalTime();
                Navigator.pop(context, selectedTime);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build the [NumberPicker] for hours and minutes
  Widget _buildNumberPicker({
    required int value,
    required int minValue,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      color: AppColors.calenderItemBackGroundColor,
      child: NumberPicker(
        value: value,
        minValue: minValue,
        maxValue: maxValue,
        zeroPad: true,
        infiniteLoop: true,
        itemWidth: 64.w,
        itemHeight: 40.h,
        onChanged: onChanged,
        textStyle: Styles.text16().copyWith(color: AppColors.gray1TextColor),
        selectedTextStyle: Styles.text24(),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white),
            bottom: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Helper to build the AM/PM Selector
  Widget _buildTimeFormatSelector(
      BuildContext context, TimePickerState state, TimePickerCubit cubit) {
    return Expanded(
      child: Column(
        children: [
          _buildTimeFormatButton(
            label: "AM",
            isSelected: state.timeFormat == "AM",
            onTap: () => cubit.setTimeFormat("AM"),
          ),
          const SizedBox(height: 15),
          _buildTimeFormatButton(
            label: "PM",
            isSelected: state.timeFormat == "PM",
            onTap: () => cubit.setTimeFormat("PM"),
          ),
        ],
      ),
    );
  }

  /// Helper to build each time format button (AM/PM)
  Widget _buildTimeFormatButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.h,
        width: 55.w,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.grey.shade700,
          border: Border.all(
            color: isSelected ? Colors.grey : Colors.grey.shade700,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Styles.text16(),
        ),
      ),
    );
  }
}
