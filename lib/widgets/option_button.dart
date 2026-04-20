import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;
  final Color accentColor;

  const OptionButton({
    super.key,
    required this.optionText,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (!isAnswered) return Colors.grey.shade100;
      if (isCorrect) return Colors.green.shade400;
      if (isSelected && !isCorrect) return Colors.red.shade400;
      return Colors.grey.shade100;
    }

    Color getTextColor() {
      if (!isAnswered) return accentColor;
      if (isCorrect || isSelected) return Colors.white;
      return accentColor.withValues(alpha: 0.5);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: getBackgroundColor(),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isAnswered && isCorrect ? Colors.green : accentColor.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: getTextColor(),
                    ),
                  ),
                ),
                if (isAnswered)
                  Icon(
                    isCorrect ? Icons.check_circle : (isSelected ? Icons.cancel : null),
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
