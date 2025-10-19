import 'package:desmodus_app/utils/constants.dart' show appVersion;
import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:desmodus_app/viewmodel/detector_controller.dart'
    show DetectorController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:permission_handler/permission_handler.dart'
    as AppSettings
    show openAppSettings;
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final wipMailNotification = false.obs;
    final wipWhatsappNotification = false.obs;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Info user
              UserInformationWidget(authController: authController),
              // Datos personales
              SettingsSection(
                contentWidget: Obx(
                  () => Column(
                    children:
                        (authController.isSignedId)
                            ? [
                              SettingsItemTile(
                                title: "Editar datos personales",
                                onTap: () => Get.offAndToNamed("cuestionario"),
                              ),
                              SettingsItemTile(
                                title: "Cerrar sesión",
                                showChevron: false,
                                onTap: () => authController.cerrarSesion(),
                              ),
                            ]
                            : [
                              SettingsItemTile(
                                title: "Iniciar sesión",
                                onTap: () => Get.toNamed("/login"),
                              ),
                            ],
                  ),
                ),
                icon: Icon(Icons.person),
                sectorTitle: "Perfil",
              ),
              16.pv,
              // Notificaciones
              SettingsSection(
                contentWidget: Column(
                  children: [
                    SettingsItemTile(
                      title: "Notificaciones de aplicación",
                      onTap: () async {
                        await showSettingsRedirectDialog(context);
                        AppSettings.openAppSettings();
                      },
                    ),
                    Obx(
                      () => SettingsSwitchTile(
                        value: wipMailNotification.value,
                        onChanged: (e) {
                          wipMailNotification.value = e;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Funcionalidad en desarrollo"),
                            ),
                          );
                        },
                        title: "Notificaciones por correo",
                      ),
                    ),
                    Obx(
                      () => SettingsSwitchTile(
                        value: wipWhatsappNotification.value,
                        onChanged: (e) {
                          wipWhatsappNotification.value = e;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Funcionalidad en desarrollo"),
                            ),
                          );
                        },
                        title: "Notificaciones por whatsapp",
                      ),
                    ),
                  ],
                ),
                icon: Icon(Icons.notifications),
                sectorTitle: "Notificaciones",
              ),
              16.pv,
              // Calibración de detector
              SettingsSection(
                contentWidget: Column(
                  children: [
                    SettingsItemTile(
                      title: "Cambiar modelo de detección",
                      onTap: () => showSelectModelDialog(context),
                    ),
                    SettingsItemTile(
                      title: "Redefinir umbral de detección",
                      onTap: () => showThresholdSelector(context),
                    ),
                  ],
                ),
                icon: Icon(Icons.camera_alt),
                sectorTitle: "Calibración",
              ),
              16.pv,
              // Contacto
              SettingsSection(
                contentWidget: Column(
                  children: [
                    SettingsItemTile(
                      title: "Teléfono",
                      subtitle: Text("+51 013 133 300"),
                      showChevron: true,
                      onTap: () {
                        // Deeplink to phone app
                        launchUrl(
                          Uri.parse("tel:+51 013 133 300"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    // SettingsItemTile(
                    //   title: "Whatsapp",
                    //   subtitle: Text("+51 013 133 300"),
                    //   showChevron: false,
                    // ),
                    SettingsItemTile(
                      title: "Correo",
                      subtitle: Text("excelenciaenelservicio@senasa.gob.pe"),
                      showChevron: true,
                      onTap: () {
                        launchUrl(
                          Uri.parse(
                            "mailto:excelenciaenelservicio@senasa.gob.pe",
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ],
                ),
                icon: Icon(Icons.phone),
                sectorTitle: "Contacto",
              ),
              16.pv,
              // Acerca de
              SettingsSection(
                contentWidget: Column(
                  children: [
                    SettingsItemTile(
                      title: "Versión",
                      subtitle: FutureBuilder<String>(
                        future: appVersion(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Text(snapshot.data!);
                        },
                      ),
                      onTap: () {
                        launchUrl(
                          Uri.parse(
                            "https://github.com/jesufrancesco/lissachatina-web",
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      showChevron: false,
                    ),
                    SettingsItemTile(
                      title: "Términos y condiciones",
                      onTap: () => showTOSDialog(context),
                    ),
                  ],
                ),
                icon: const Icon(Icons.info),
                sectorTitle: "Acerca de",
              ),
              48.pv,
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showSettingsRedirectDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Permisos de notificaciones"),
          content: const Text(
            "Para desactivar las notificaciones, quita los permisos de notificaciones en la configuración de la aplicación.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void showThresholdSelector(BuildContext context) {
    final detectorController = Get.find<DetectorController>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Umbral de detección"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Aquí va el selector de umbral"),
              16.ph,
              Obx(
                () => Slider(
                  value: detectorController.detectionThreshold.value,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  label: "${detectorController.detectionThreshold.value}",
                  onChanged: (value) {
                    Get.snackbar("WIP Modelo", "Funcionalidad en proceso");
                    // detectorController.setDetectionThreshold(value);
                    // detectorController.savePreferredThreshold();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void showSelectModelDialog(BuildContext context) {
    final detectorController = Get.find<DetectorController>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modelo de detección"),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  detectorController.localModelsInstalled.map((model) {
                    return RadioListTile<String>(
                      title: Text(model),
                      value: model,
                      groupValue: detectorController.detectionModel.value,
                      onChanged: (value) {
                        if (value != null) {
                          Get.snackbar(
                            "WIP Modelo",
                            "Funcionalidad en proceso",
                          );
                          // detectorController.setSelectedModel(value);
                          // detectorController.savePreferredModel();
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void showTOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Términos y condiciones"),
          content: const Text("Aquí van los términos y condiciones"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }
}

class UserInformationWidget extends StatelessWidget {
  const UserInformationWidget({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 120,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // == User avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "${authController.userData.value.avatarUrl}",
              ),
              backgroundColor: Colors.grey[200], // fallback background
            ),
            20.ph,
            // == User Information (text)
            Flexible(
              child: Obx(
                () =>
                    (authController.isLoading.value)
                        ? const CircularProgressIndicator()
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                authController.userData.toJson()["name"] ??
                                    "Anónimo",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            4.ph,
                            Obx(
                              () => Text(
                                authController.userData.toJson()["email"] ??
                                    "User",
                                style: Theme.of(context).textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final Icon icon;
  final String sectorTitle;
  final Widget contentWidget;

  const SettingsSection({
    super.key,
    required this.contentWidget,
    required this.icon,
    required this.sectorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            8.ph,
            Text(sectorTitle, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
        contentWidget,
      ],
    );
  }
}

class SettingsItemTile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const SettingsItemTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle,
      trailing: showChevron ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
      enabled: true,
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
