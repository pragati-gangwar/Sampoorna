import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../constant.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';
class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Container(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.person_add,
            size: 36,),

            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: isDarkTheme
                    ? Dcream
                    : Lcream,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}