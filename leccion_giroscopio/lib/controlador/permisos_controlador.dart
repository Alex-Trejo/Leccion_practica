import 'package:permission_handler/permission_handler.dart';

class PermisosControlador {
  /// Solicita los permisos necesarios para usar el giroscopio.
  Future<bool> solicitarPermisos() async {
    try {
      // Verificar el estado del permiso para sensores
      final permiso = await Permission.sensors.status;

      if (permiso.isDenied) {
        // Si el permiso está denegado, solicitarlo
        final status = await Permission.sensors.request();
        if (status.isGranted) {
          return true; // Permiso otorgado
        } else {
          return false; // Permiso denegado
        }
      }
      // Permiso ya está otorgado
      return permiso.isGranted;
    } catch (e) {
      print("Error al solicitar permisos: $e");
      return false; // En caso de error, retornar false
    }
  }
}
