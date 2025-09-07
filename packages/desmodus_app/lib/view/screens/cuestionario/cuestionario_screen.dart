import 'package:desmodus_app/viewmodel/auth_controller.dart'
    show AuthController;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart';

class CuestionarioScreen extends StatefulWidget {
  const CuestionarioScreen({super.key});

  @override
  State<CuestionarioScreen> createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  final controller = Get.find<AuthController>();

  // Form controllers
  final nombresCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final nroDocCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final referenciaCtrl = TextEditingController();

  // Dropdown values
  String? tipoDoc;
  String? departamento;
  String? provincia;
  String? distrito;
  String? centroPoblado;

  Widget buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Title + Logo
            Text(
              'Completa tu información',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // const SizedBox(height: 10),
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
            // const SizedBox(height: 20),

            // Datos del noticiante
            buildSectionCard(
              title: "Datos del noticiante",
              children: [
                TextField(
                  controller: nombresCtrl,
                  decoration: customInputDecoration("Nombres", Icons.person),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: apellidosCtrl,
                  decoration: customInputDecoration(
                    "Apellidos",
                    Icons.person_outline,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: tipoDoc,
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
                  onChanged: (val) => setState(() => tipoDoc = val),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: nroDocCtrl,
                  decoration: customInputDecoration("Nº Doc.", Icons.numbers),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            // Datos de contacto
            buildSectionCard(
              title: "Datos de contacto",
              children: [
                TextField(
                  controller: direccionCtrl,
                  decoration: customInputDecoration("Dirección", Icons.home),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: telefonoCtrl,
                  decoration: customInputDecoration("Teléfono", Icons.phone),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: correoCtrl,
                  decoration: customInputDecoration(
                    "Correo electrónico",
                    Icons.email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),

            // Ubicación
            buildSectionCard(
              title: "Ubicación de la zona afectada",
              children: [
                DropdownButtonFormField<String>(
                  value: departamento,
                  decoration: customInputDecoration("Departamento", Icons.map),
                  items:
                      ["Lima", "Cusco", "Piura"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => departamento = val),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: provincia,
                  decoration: customInputDecoration(
                    "Provincia",
                    Icons.location_city,
                  ),
                  items:
                      ["Provincia 1", "Provincia 2", "Provincia 3"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => provincia = val),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: distrito,
                  decoration: customInputDecoration(
                    "Distrito",
                    Icons.location_on,
                  ),
                  items:
                      ["Distrito 1", "Distrito 2", "Distrito 3"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => distrito = val),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: centroPoblado,
                  decoration: customInputDecoration(
                    "Centro poblado",
                    Icons.villa,
                  ),
                  items:
                      ["Centro 1", "Centro 2", "Centro 3"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => centroPoblado = val),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: referenciaCtrl,
                  decoration: customInputDecoration(
                    "Referencia",
                    Icons.edit_location,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Confirmar Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                controller.usuarioCompleto.value = true;
                print("Usuario completo: ${controller.usuarioCompleto.value}");
                Get.offNamed("/home");
              },
              icon: Icon(Icons.check, color: Colors.white),
              label: Text(
                "Confirmar",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
