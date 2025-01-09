import 'package:flutter/material.dart';
import '../controlador/giroscopio_controlador.dart';
import '../controlador/websocket_controlador.dart';
import '../controlador/permisos_controlador.dart';
import '../utils/constantes.dart';

class GiroscopioPage extends StatefulWidget {
  @override
  _GiroscopioPageState createState() => _GiroscopioPageState();
}

class _GiroscopioPageState extends State<GiroscopioPage> {
  final GiroscopioControlador _giroscopioControlador = GiroscopioControlador();
  final WebSocketControlador _webSocketControlador = WebSocketControlador(servidorWebSocket);
  final PermisosControlador _permisosControlador = PermisosControlador();

  @override
  void initState() {
    super.initState();
    _verificarPermisos();
  }

  Future<void> _verificarPermisos() async {
    final permisosOtorgados = await _permisosControlador.solicitarPermisos();
    if (!permisosOtorgados) {
      _mostrarDialogoPermisos();
    }
  }

  void _mostrarDialogoPermisos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permiso Requerido"),
          content: const Text(
            "El permiso para acceder al giroscopio es necesario para usar esta función.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _giroscopioControlador.detenerEscucha();
    _webSocketControlador.cerrarConexion();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Control por Giroscopio")),
      body: StreamBuilder(
        stream: _giroscopioControlador.obtenerEventosGiroscopio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Cargando datos del giroscopio..."));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Esperando datos..."));
          }

          final event = snapshot.data;
          if (event == null) return const Center(child: Text("Datos no disponibles."));

          String comando = determinarComando(event.x, event.y, event.z);

          if (comando.isNotEmpty) {
            debugPrint("Enviando comando: $comando");
            _webSocketControlador.enviarComando(comando);
          }

          return Center(
            child: Text(
              "X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
          );
        },
      ),
    );
  }

  String determinarComando(double x, double y, double z) {
    if (x >2) {
      return "abrir_word";
    } else if (y > 2) {
      return "abrir_excel";
    } else if (z > 2) {
      return "reproducir_musica";
    }
    return "";
  }
}
