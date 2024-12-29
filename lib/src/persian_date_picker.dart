import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_easy_date_picker/src/custom_stepper.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDatePicker {
  static Future<String> pick({
    required BuildContext context,
    required Function(String) onError,
    bool? showStepper,
    int? startYear,
    int? endYear,
    String? title,
    double? borderRadius,
    Color? backgroundColor,
    Color? textColor,
    bool? canSelectPastTime,
    bool? canSelectFutureTime,
    bool? blurredBackground,
    bool? autoPick,
    Color? nextButtonColor,
    String? nextButtonText,
    String? doneButtonText,
    Color? cancelButtonColor,
    String? cancelButtonText,
  }) async {
    String? selectedYear;
    String? selectedMonth;
    String? selectedDay;
    String selectedDate = '--/--/--';
    title ??= "انتخاب تاریخ";
    startYear ??= 1290;
    endYear ??= 1480;
    autoPick ??= true;
    nextButtonColor??=Colors.blue;
    nextButtonText??='ادامه';
    doneButtonText??='پایان';
    cancelButtonColor??=Colors.red;
    cancelButtonText??='لغو';
    canSelectPastTime ??= true;
    canSelectFutureTime ??= true;
    blurredBackground ??= false;
    showStepper ??= true;
    borderRadius ??= 8.0;
    backgroundColor ??= const Color(0xFFFFFFFF);
    textColor ??= const Color(0xFF000000);

    selectedYear = await _pickYearDialog(
      context,
      title,
      borderRadius,
      backgroundColor,
      textColor,
      showStepper,
      startYear,
      endYear,
      blurredBackground,
      autoPick,
      nextButtonColor,
    nextButtonText,
    cancelButtonColor,
    cancelButtonText,
    );

    if (selectedYear != null && selectedYear != cancelButtonText) {
      if (!canSelectPastTime && int.parse(selectedYear) < Jalali.now().year) {
        onError('Past dates are not allowed.');
        return '--/--/--';
      }
      if (!canSelectFutureTime && int.parse(selectedYear) > Jalali.now().year) {
        onError('Future dates are not allowed.');
        return '--/--/--';
      }

      selectedMonth = await _pickMonthDialog(
        context,
        title,
        borderRadius,
        backgroundColor,
        textColor,
        selectedYear,
        showStepper,
        blurredBackground,
        autoPick,
        nextButtonColor,
        nextButtonText,
        cancelButtonColor,
        cancelButtonText,
      );

      if (selectedMonth != null && selectedMonth != cancelButtonText) {
        selectedDay = await _pickDayDialog(
          context,
          title,
          borderRadius,
          backgroundColor,
          textColor,
          int.parse(selectedYear),
          selectedMonth,
          showStepper,
          blurredBackground,
          autoPick,
          nextButtonColor,
          doneButtonText,
          cancelButtonColor,
          cancelButtonText,
        );

        if (selectedDay != null && selectedDay != cancelButtonText) {
          final selectedDateTime = Jalali(
            int.parse(selectedYear),
            int.parse(selectedMonth),
            int.parse(selectedDay),
          ).toDateTime();

          final currentDateTime = Jalali.now().toDateTime();

          if (!canSelectPastTime &&
              selectedDateTime.isBefore(currentDateTime)) {
            onError('Past dates are not allowed.');
            return '--/--/--';
          }
          if (!canSelectFutureTime &&
              selectedDateTime.isAfter(currentDateTime)) {
            onError('Future dates are not allowed.');
            return '--/--/--';
          }

          selectedDate = '${selectedYear}/${selectedMonth}/${selectedDay}';
          return selectedDate;
        }
      }
    }

    onError('Dismissed by user.');
    return '--/--/--';
  }

  static Future<String?> _pickYearDialog(
    BuildContext context,
    String title,
    double borderRadius,
    Color backgroundColor,
    Color textColor,
    bool showStepper,
    int startYear,
    int endYear,
    bool blurredBackground,
      bool autoNext,
      Color nextButtonColor,
      String nextButtonText,
      Color cancelButtonColor,
      String cancelButtonText,

  ) async {
    int selectedYear = (endYear - startYear) ~/ 2;
    ScrollController scrollController = ScrollController();

    double initialOffset = ((endYear - startYear) ~/ 4) * 50.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(initialOffset);
    });

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      color: Colors.black
                          .withOpacity(blurredBackground ? 0.5 : 0.0),
                    ),
                  ),
                  Center(
                    child: AlertDialog(
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: textColor, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '--/--/--',
                            style: TextStyle(color: textColor, fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),
                          Visibility(
                            visible: showStepper,
                            child: const Column(
                              children: [
                                Divider(),
                                CustomHorizontalStepper(
                                  steps: ['سال', 'ماه', 'روز'],
                                  currentStep: 0,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            //  mainAxisSpacing: 8,
                            // crossAxisSpacing: 8,
                          ),
                          itemCount: endYear - startYear + 1,
                          itemBuilder: (context, index) {
                            final year = startYear + index;
                            return GestureDetector(
                              onTap: () {
                                selectedYear = year;
                                setState(() {});
                                if(autoNext){
                                  Navigator.pop(context, selectedYear.toString());
                                }

                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.1),
                                  color: selectedYear == year
                                      ? textColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  //  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  year.toString(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(

                              onPressed: () {
                                Navigator.pop(context, cancelButtonText);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cancelButtonColor,
                              ),
                              child: Text(cancelButtonText,style:const TextStyle(color: Colors.white)),
                            ),
                            Visibility(
                              visible: autoNext?false:true,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: nextButtonColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, selectedYear.toString());
                                },
                                child: Text(nextButtonText,style:const TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Future<String?> _pickMonthDialog(
    BuildContext context,
    String title,
    double borderRadius,
    Color backgroundColor,
    Color textColor,
    String selectedYear,
    bool showStepper,
    bool blurredBackground,
      bool autoNext,
     Color nextButtonColor,
      String nextButtonText,
      Color  cancelButtonColor,
     String cancelButtonText,
  ) async {
    final months = [
      "فروردین",
      "اردیبهشت",
      "خرداد",
      "تیر",
      "مرداد",
      "شهریور",
      "مهر",
      "آبان",
      "آذر",
      "دی",
      "بهمن",
      "اسفند"
    ];
    String selectedMonth = months[0];
    int selectedIndex = 0;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black
                          .withOpacity(blurredBackground ? 0.5 : 0.0),
                    ),
                  ),
                  Center(
                    child: AlertDialog(
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: textColor, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$selectedYear/--/--',
                            style: TextStyle(color: textColor, fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),
                          Visibility(
                            visible: showStepper,
                            child: const Column(
                              children: [
                                Divider(),
                                CustomHorizontalStepper(
                                  steps: ['سال', 'ماه', 'روز'],
                                  currentStep: 1,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          itemCount: months.length,
                          itemBuilder: (context, index) {

                            final month = months[index];
                            return GestureDetector(
                              onTap: () {
                                selectedIndex = index;
                                selectedMonth = month;
                                setState(() {});
                                if(autoNext){
                                  Navigator.pop(context,
                                      (index + 1).toString().padLeft(2, '0'));
                                }

                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selectedMonth == month
                                      ? textColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.1),
                                  //borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  month,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(

                              onPressed: () {
                                Navigator.pop(context, cancelButtonText);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cancelButtonColor,
                              ),
                              child: Text(cancelButtonText,style:const TextStyle(color: Colors.white)),
                            ),
                            Visibility(
                              visible: autoNext?false:true,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: nextButtonColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context,
                                      (selectedIndex + 1).toString().padLeft(2, '0'));
                                },
                                child: Text(nextButtonText,style:const TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Future<String?> _pickDayDialog(
    BuildContext context,
    String title,
    double borderRadius,
    Color backgroundColor,
    Color textColor,
    int selectedYear,
    String selectedMonth,
    bool showStepper,
    bool blurredBackground,
      bool autoNext,
      Color doneButtonColor,
      String doneButtonText,
      Color  cancelButtonColor,
      String cancelButtonText,
  ) async {
    int selectedDay = 1;
    final daysOfWeek = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه'
    ];
    int daysInMonth;
    if (selectedMonth == '12') {
      daysInMonth = (selectedYear % 4 == 0 &&
              (selectedYear % 100 != 0 || selectedYear % 400 == 0))
          ? 30
          : 29;
    } else if (['1', '3', '5', '7', '8', '10', '12'].contains(selectedMonth)) {
      daysInMonth = 31;
    } else {
      daysInMonth = 30;
    }
    int firstWeekdayIndex;
    try {
      final jDate =
          Jalali(selectedYear, int.parse(selectedMonth), 1).toGregorian();
      firstWeekdayIndex = jDate.weekDay % 7 + 1;
    } catch (e) {
      firstWeekdayIndex = 0;
    }

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(blurredBackground
                          ? 0.5
                          : 0.0), // رنگ تیره برای پس‌زمینه بلور
                    ),
                  ),
                  Center(
                    child: AlertDialog(
                      backgroundColor: backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: textColor, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$selectedYear/$selectedMonth/--',
                            style: TextStyle(color: textColor, fontSize: 16),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: showStepper,
                            child: const Column(
                              children: [
                                Divider(),
                                CustomHorizontalStepper(
                                  steps: ['سال', 'ماه', 'روز'],
                                  currentStep: 2,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                          ),
                          itemCount: daysInMonth,
                          itemBuilder: (context, index) {
                            final day = index + 1;
                            final weekDay =
                                daysOfWeek[(firstWeekdayIndex + index) % 7];
                            return GestureDetector(
                              onTap: () {
                                selectedDay = day;
                                setState(() {});
                                if(autoNext){
                                  Navigator.pop(
                                      context, day.toString().padLeft(2, '0'));
                                }

                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selectedDay == day
                                      ? textColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: Colors.grey, width: 0.1),
                                  //  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      day.toString(),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      weekDay,
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.7),
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(

                              onPressed: () {
                                Navigator.pop(context, cancelButtonText);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cancelButtonColor,
                              ),
                              child: Text(cancelButtonText,style:const TextStyle(color: Colors.white)),
                            ),
                            Visibility(
                              visible: autoNext?false:true,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: doneButtonColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                      context, selectedDay.toString().padLeft(2, '0'));
                                },
                                child: Text(doneButtonText,style:const TextStyle(color: Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
