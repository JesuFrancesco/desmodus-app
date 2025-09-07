import 'package:desmodus_app/view/screens/login/widget/facebook_sign_in.dart';
import 'package:desmodus_app/view/screens/login/widget/map_redirect.dart';
import 'package:flutter/material.dart';
import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/view/screens/login/widget/app_logo.dart';
import 'package:desmodus_app/view/screens/login/widget/discord_sign_in.dart';
import 'package:desmodus_app/view/screens/login/widget/google_sign_in.dart';
import 'package:desmodus_app/view/screens/login/widget/no_auth_access.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart';
import 'package:get/get.dart';
import 'package:desmodus_app/view/screens/login/widget/chatbot_redirect.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Desmodus App',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            // LOGO
            AppLogoWidget(),
            // AUTH PROVIDERS
            GoogleSignInButton(),
            DiscordSignInButton(),
            FacebookSignInButton(),
            // DIVIDER
            ShortDivider(),
            // NO AUTH ACCESS BUTTON
            NoAuthAccessButton(),
            MapButton(),
            ChatbotButton(),
          ],
        ),
      ),
    );
  }
}

class ShortDivider extends StatelessWidget {
  const ShortDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 50,
      indent: 50,
      thickness: 2,
      color:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
    );

    return Row(
      children: [
        Expanded(child: divider),
        10.ph,
        Text('O', style: Theme.of(context).textTheme.titleSmall),
        10.ph,
        divider,
      ],
    );
  }
}
