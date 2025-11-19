import 'package:desmodus_app/utils/cookies.dart';
import 'package:desmodus_app/utils/strings.dart';
import 'package:desmodus_app/viewmodel/auth_controller.dart';
import 'package:flutter/material.dart' show debugPrint, FormState, GlobalKey;
import 'package:get/get.dart';
import 'package:desmodus_app/model/entity/departamento.dart';
import 'package:desmodus_app/model/entity/distrito.dart' show Distrito;
import 'package:desmodus_app/model/entity/provincia.dart' show Provincia;
import 'package:desmodus_app/model/service/remote/cuestionario_service.dart';
import 'package:desmodus_app/model/service/remote/ubigeo_service.dart';

class CuestionarioController extends GetxController {
  // Services
  final service = CuestionarioService();

  // Controllers
  final isControllerLoading = true.obs;
  final isUbigeoLoading = true.obs;
  final isSaving = false.obs;

  // Completados por payload
  final nombres = "".obs;
  final apellidos = "".obs;
  final correo = "".obs;

  // Other info
  final nroDoc = RxnString();
  final telefono = RxnString();
  final direccion = RxnString();
  final tipoDoc = RxnString();

  final departamento = RxnString();
  final provincia = RxnString();
  final distrito = RxnString();

  final centroPoblado = RxnString();
  final referencia = RxnString();

  // Service information
  final departamentosList = <Departamento>[].obs;
  final provinciasList = <Provincia>[].obs;
  final distritosList = <Distrito>[].obs;

  @override
  void dispose() {
    super.dispose();
    nombres.close();
    apellidos.close();
    correo.close();
    nroDoc.close();
    telefono.close();
    direccion.close();
    tipoDoc.close();
    departamento.close();
    provincia.close();
    distrito.close();
    centroPoblado.close();
    referencia.close();

    departamentosList.close();
    provinciasList.close();
    distritosList.close();

    isControllerLoading.close();
    isUbigeoLoading.close();
  }

  @override
  void onInit() async {
    super.onInit();

    final userData = Get.find<AuthController>().userData;

    for (var entry in splitNombreApellido(userData.value.name).entries) {
      if (entry.key == 'nombres') {
        nombres.value = entry.value;
      } else if (entry.key == 'apellidos') {
        apellidos.value = entry.value;
      }
    }

    // TODO: fix location fetching
    // final locationController = Get.find<LocationController>();
    // if (locationController.hasPermission.value == true) {
    //   final latLong = await locationController.obtenerUbicacionActual();
    //   final places = await getPlacemarksFromLatLong(
    //       latLong['latitud']!, latLong['longitud']!);

    //   if (places.isNotEmpty) {
    //     final place = places.first;
    //     departamento.value = place.administrativeArea;
    //     provincia.value = place.subAdministrativeArea;
    //     distrito.value = place.locality;
    //     centroPoblado.value = place.subLocality;
    //     direccion.value =
    //         "${place.street}, ${place.subLocality}, ${place.locality}";
    //   }
    // } else {
    //   debugPrint(
    //       "⚠️ Advertencia: No se pudo obtener la ubicación. Permiso denegado.");
    // }

    correo.value = userData.value.email;
    nroDoc.value = userData.value.dni;
    telefono.value = userData.value.phone;
    tipoDoc.value = userData.value.documentType;
    direccion.value = userData.value.address;
    centroPoblado.value = userData.value.centroPoblado;

    if (userData.value.distritoId != null) {
      await updateUbigeos(reloadDepartamentos: true);
      departamento.value = userData.value.distritoId!.substring(0, 2);
      await updateUbigeos(reloadProvincias: true);
      provincia.value = userData.value.distritoId!.substring(0, 4);
      await updateUbigeos(reloadDistritos: true);
      distrito.value = userData.value.distritoId;
    } else {
      await updateUbigeos(reloadDepartamentos: true);
    }
    distrito.value = userData.value.distritoId;

    isControllerLoading.value = false;
  }

  Future<void> updateUbigeos({
    bool? reloadDepartamentos,
    bool? reloadProvincias,
    bool? reloadDistritos,
  }) async {
    isUbigeoLoading.value = true;
    try {
      final service = UbigeoService();
      if (reloadDepartamentos == true) {
        departamento.value = null;
        provincia.value = null;
        distrito.value = null;
        provinciasList.clear();
        distritosList.clear();

        departamentosList.value = await service.listarDepartamentos();
      }
      if (reloadProvincias == true) {
        distrito.value = null;
        provincia.value = null;
        distritosList.clear();

        provinciasList.value = await service.listarProvincias(
          departamento.value!,
        );
      }
      if (reloadDistritos == true) {
        distrito.value = null;
        distritosList.value = await service.listarDistritos(provincia.value!);
      }
    } catch (e) {
      debugPrint("Error actualizando ubigeos: $e");
    } finally {
      isUbigeoLoading.value = false;
    }
  }

  Future<void> guardarDatos(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    // final formData = {
    //   "nombres": nombres.value,
    //   "apellidos": apellidos.value,
    //   "tipoDoc": tipoDoc.value,
    //   "nroDoc": nroDoc.value,
    //   "direccion": direccion.value,
    //   "telefono": telefono.value,
    //   "correo": correo.value,
    //   "referencia": referencia.value,
    //   "departamento": departamento.value,
    //   "provincia": provincia.value,
    //   "distrito": distrito.value,
    //   "centroPoblado": centroPoblado.value,
    // };

    // debugPrint("Campos\n---");
    // for (var entry in formData.entries) {
    //   if (entry.value == null ||
    //       (entry.value is String && entry.value!.isEmpty)) {
    //     debugPrint("⚠️ Advertencia: El campo '${entry.key}' está vacío.");
    //   }
    //   debugPrint("${entry.key}: ${entry.value}");
    // }

    final patchData = {
      "name": "${nombres.value} ${apellidos.value}",
      "email": correo.value,
      "phone": telefono.value,
      "dni": nroDoc.value,
      // TODO: actualizar base de datos
      "documentType": tipoDoc.value,
      "address": direccion.value,
      "centroPoblado": centroPoblado.value,
      "distritoId": distrito.value,
      // "referenciaCentro": referencia.value,
    };

    try {
      isSaving.value = true;
      final accessToken = await getCookie("access_token");
      await service.guardarDatos(accessToken!, patchData);
      Get.snackbar("Éxito", "Los datos se han guardado correctamente.");
      Get.offAllNamed("/home");
    } catch (e) {
      Get.snackbar(
        "Error",
        "No se pudieron guardar los datos, inténtelo de nuevo o más tarde.",
      );
    } finally {
      isSaving.value = false;
    }
  }
}
