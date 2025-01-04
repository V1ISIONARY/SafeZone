import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class CustomRadioButton extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final ValueChanged<String?>? onChanged;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(value),
      child: Row(
        children: [
          Radio<String?>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: btnColor.withOpacity(0.5),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
