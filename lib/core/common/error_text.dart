import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/theme/app_colors.dart';
import 'package:hackathon_proj/theme/font_provider.dart';

class ErrorText extends ConsumerWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsize = ref.watch(fontSizesProvider);
    return Text(
      error,
      style: TextStyle(
          color: Lpurple1,
          fontSize: fontsize.headingSize,
          fontWeight: FontWeight.bold),
    );
  }
}
