import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timeLeft;
  final int totalTime;

  const TimerWidget({
    super.key,
    required this.timeLeft,
    this.totalTime = 15,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowTime = timeLeft <= 5;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kalan Süre",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLowTime ? Colors.red : Colors.grey.shade600,
              ),
            ),
            Text(
              "$timeLeft saniye",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLowTime ? Colors.red : Colors.blueGrey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: timeLeft / totalTime,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isLowTime ? Colors.red : Colors.blueAccent,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
