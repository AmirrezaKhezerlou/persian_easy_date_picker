import 'package:flutter/material.dart';

class CustomHorizontalStepper extends StatelessWidget {
  final int currentStep; // مرحله فعلی
  final List<String> steps; // نام مراحل

  const CustomHorizontalStepper({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // خط بین دایره‌ها
          final isActive = (index ~/ 2) < currentStep;
          return Flexible(
            child: Container(
              height: 2,
              color: isActive ? Colors.green : Colors.grey[300],
            ),
          );
        } else {
          // دایره و نام مرحله
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep; // آیا این مرحله فعال است؟
          final isCurrent = stepIndex == currentStep; // آیا این مرحله جاری است؟
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? (isCurrent ? Colors.blue : Colors.green)
                      : Colors.grey[300],
                ),
                child: Center(
                  child: Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.grey,
                  fontSize: 12,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
