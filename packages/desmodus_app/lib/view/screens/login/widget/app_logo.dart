import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/image/logo.svg',
      width: 320.0,
      height: 320.0,
      colorFilter: ColorFilter.mode(
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
