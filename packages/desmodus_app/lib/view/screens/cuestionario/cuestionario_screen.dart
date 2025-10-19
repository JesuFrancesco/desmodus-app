import 'package:desmodus_app/utils/padding_extensions.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart';
import 'package:desmodus_app/viewmodel/controllers/cuestionario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';

class CuestionarioScreen extends StatelessWidget {
  const CuestionarioScreen({super.key});

  AuthController get authController => Get.find<AuthController>();
  CuestionarioController get controller => Get.find<CuestionarioController>();
  static final _formKey = GlobalKey<FormState>();

  Widget buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            12.pv,
            ...children,
          ],
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Get.theme.colorScheme.primary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Get.theme.colorScheme.primary, width: 2),
      ),
    );
  }

  bool get isEditingMode => Get.parameters['editingMode'] == "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              40.pv,
              // Title + Logo
              Text(
                isEditingMode
                    ? "Editar datos del noticiante"
                    : "Completa tu perfil",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SvgPicture.asset(
                'assets/image/logo.svg',
                width: 200.0,
                height: 200.0,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  BlendMode.srcIn,
                ),
              ),

              // Datos del noticiante
              buildSectionCard(
                title: "Datos del noticiante",
                children: [
                  Obx(
                    () => TextFormField(
                      initialValue: controller.nombres.value,
                      onChanged: (val) => controller.nombres.value = val,
                      decoration: customInputDecoration(
                        "Nombres",
                        Icons.person,
                      ),
                    ),
                  ),
                  10.pv,
                  Obx(
                    () => TextFormField(
                      initialValue: controller.apellidos.value,
                      onChanged: (val) => controller.apellidos.value = val,
                      decoration: customInputDecoration(
                        "Apellidos",
                        Icons.person_outline,
                      ),
                    ),
                  ),
                  10.pv,
                  DropdownButtonFormField<String>(
                    initialValue: controller.tipoDoc.value,
                    decoration: customInputDecoration(
                      "Tipo Doc.",
                      Icons.credit_card,
                    ),
                    items:
                        ["DNI", "Carnet Extranjería", "Pasaporte"]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) => controller.tipoDoc.value = val ?? "",
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Seleccione tipo de documento";
                      }
                      return null;
                    },
                  ),
                  10.pv,
                  Obx(
                    () => TextFormField(
                      initialValue: controller.nroDoc.value,
                      onChanged: (val) => controller.nroDoc.value = val,
                      decoration: customInputDecoration(
                        "Nº Doc.",
                        Icons.numbers,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Ingrese número de documento";
                        }
                        if (!RegExp(r'^[0-9]{8,12}$').hasMatch(val)) {
                          return "Documento inválido (solo números de 8 o 12 dígitos)";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // Datos de contacto
              buildSectionCard(
                title: "Datos de contacto",
                children: [
                  Obx(
                    () => TextFormField(
                      initialValue: controller.correo.value,
                      onChanged: (val) => controller.correo.value = val,
                      decoration: customInputDecoration(
                        "Correo electrónico",
                        Icons.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Ingrese correo electrónico";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(val)) {
                          return "Correo inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                  10.pv,
                  Obx(
                    () => TextFormField(
                      initialValue: controller.telefono.value,
                      onChanged: (val) => controller.telefono.value = val,
                      decoration: customInputDecoration(
                        "Teléfono",
                        Icons.phone,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Ingrese número de teléfono";
                        }
                        if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(val)) {
                          return "Teléfono inválido (solo números de 7 a 15 dígitos)";
                        }
                        return null;
                      },
                    ),
                  ),
                  10.pv,
                  Obx(
                    () => TextFormField(
                      initialValue: controller.direccion.value,
                      onChanged: (val) => controller.direccion.value = val,
                      decoration: customInputDecoration(
                        "Dirección",
                        Icons.home,
                      ),
                    ),
                  ),
                ],
              ),

              // Ubicación
              buildSectionCard(
                title: "Ubicación de la zona afectada (opcional)",
                children: [
                  Obx(
                    () =>
                        controller.isUbigeoLoading.value
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                            : Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  decoration: customInputDecoration(
                                    "Departamento",
                                    Icons.map,
                                  ),
                                  items:
                                      controller.departamentosList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.nombre),
                                            ),
                                          )
                                          .toList(),
                                  initialValue: controller.departamento.value,
                                  onChanged: (val) {
                                    controller.departamento.value = val ?? "";
                                    controller.updateUbigeos(
                                      reloadProvincias: true,
                                    );
                                  },
                                ),
                                10.pv,
                                DropdownButtonFormField<String>(
                                  decoration: customInputDecoration(
                                    "Provincia",
                                    Icons.location_city,
                                  ),
                                  items:
                                      controller.provinciasList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.nombre),
                                            ),
                                          )
                                          .toList(),
                                  initialValue: controller.provincia.value,
                                  onChanged: (val) {
                                    controller.provincia.value = val ?? "";
                                    controller.updateUbigeos(
                                      reloadDistritos: true,
                                    );
                                  },
                                ),
                                10.pv,
                                DropdownButtonFormField<String>(
                                  decoration: customInputDecoration(
                                    "Distrito",
                                    Icons.location_on,
                                  ),
                                  items:
                                      controller.distritosList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.id,
                                              child: Text(e.nombre),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) =>
                                          controller.distrito.value = val ?? "",
                                  initialValue: controller.distrito.value,
                                ),
                                10.pv,
                                DropdownButtonFormField<String>(
                                  initialValue: controller.centroPoblado.value,
                                  decoration: customInputDecoration(
                                    "Centro poblado",
                                    Icons.villa,
                                  ),
                                  items:
                                      ["Centro 1", "Centro 2", "Centro 3"]
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (val) =>
                                          controller.centroPoblado.value =
                                              val ?? "",
                                ),
                              ],
                            ),
                  ),
                  10.pv,
                  TextField(
                    onChanged: (val) => controller.referencia.value = val,
                    decoration: customInputDecoration(
                      "Referencia",
                      Icons.edit_location,
                    ),
                  ),
                ],
              ),

              20.pv,

              // Confirmar Button
              Obx(
                () =>
                    controller.isSaving.value
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton.icon(
                          onPressed:
                              () =>
                                  controller.isSaving.value
                                      ? null
                                      : controller.guardarDatos(_formKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            "Confirmar",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              ),
              10.pv,
              TextButton(
                onPressed: () => Get.offNamed("/dashboard"),
                child: const Text("Omitir por ahora"),
              ),
              30.pv,
            ],
          ),
        ),
      ),
    );
  }
}
