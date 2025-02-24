import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'lib/resources/lottie/loading.json',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }
}