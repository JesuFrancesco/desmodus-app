import 'package:flutter/material.dart';
import 'package:desmodus_app/config.dart';
import 'package:desmodus_app/router.dart';
import 'package:desmodus_app/utils/global.dart';
import 'package:desmodus_app/utils/deeplink.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalApp.init();

  DeepLinkParser().iniciarDeepLinkListener();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Config.ambiente == "UNAUTHORIZED") {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Expanded(
            child: Center(
              child: Text(
                "No se han podido leer las variables de entorno, reucerda usar un .env",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return getAppRouter("/loading");
  }
}
