import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class SosButton extends StatefulWidget {
  const SosButton({Key? key}) : super(key: key);

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.95, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 175 * _animation.value,
              height: 175 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDA5C56).withOpacity(0.4),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 150 * _animation.value,
              height: 150 * _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDA5C56).withOpacity(0.7),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 135 * _animation.value,
              height: 135 * _animation.value,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDA5C56),
              ),
            );
          },
        ),
        // Center Text
        const Text(
          "SOS",
          style: TextStyle(
              color: bgColor, fontWeight: FontWeight.w800, fontSize: 20),
        )
      ],
    );
  }
}
