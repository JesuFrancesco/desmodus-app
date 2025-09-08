import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/login/widget/app_logo.dart'
    show AppLogoWidget;
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppLogoWidget(), 20.pv, CircularProgressIndicator()],
        ),
      ),
    );
  }
}
