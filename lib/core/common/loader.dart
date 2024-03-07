import 'package:flutter/material.dart';
import 'package:hackathon_proj/theme/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.purple,
        color: Lpurple1,
      ),
    );
  }
}
