import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class GiroscopioControlador {
  StreamSubscription<GyroscopeEvent>? _suscripcion;

  // Devuelve el stream de eventos del giroscopio con manejo de errores
  Stream<GyroscopeEvent> obtenerEventosGiroscopio() {
    // Ahora se maneja el error dentro del stream
    return gyroscopeEventStream().handleError((error) {
      print("Error al acceder al sensor de giroscopio: $error");
    });
  }

  // Inicia la escucha de los eventos del giroscopio
  void iniciarEscucha(Function(GyroscopeEvent) onData, {Function? onError}) {
    _suscripcion = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        // Llama a la función onData proporcionada
        onData(event);
      },
      onError: (error) {
        print("Error al escuchar eventos del giroscopio: $error");
        if (onError != null) {
          onError(error);
        }
      },
      cancelOnError: true,
    );
  }

  // Detiene la escucha de los eventos del giroscopio
  void detenerEscucha() {
    _suscripcion?.cancel();
    _suscripcion = null;
  }
}
