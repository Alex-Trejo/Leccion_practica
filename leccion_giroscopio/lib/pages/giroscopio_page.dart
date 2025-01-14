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
  final WebSocketControlador _webSocketControlador =
      WebSocketControlador(servidorWebSocket);
  final PermisosControlador _permisosControlador = PermisosControlador();

  String comandoActual = "Ninguno";

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

  void _calibrarGiroscopio() {
    setState(() {
      comandoActual = "Calibrando...";
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        comandoActual = "Ninguno";
      });
    });
  }

  void _actualizarComando(String comando) {
    if (comandoActual != comando) {
      setState(() {
        comandoActual = comando;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.control_camera, color: Colors.white),
            const SizedBox(width: 10),
            const Text("Control por Giroscopio"),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.gesture,
                color: Colors.deepPurple,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Datos del Giroscopio",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: _giroscopioControlador.obtenerEventosGiroscopio(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text(
                      "Cargando datos del giroscopio...",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text(
                      "Esperando datos...",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  );
                }

                final event = snapshot.data;
                if (event == null) {
                  return const Center(
                    child: Text(
                      "Datos no disponibles.",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  );
                }

                String comando = determinarComando(event.x, event.y, event.z);

                if (comando.isNotEmpty) {
                  debugPrint("Enviando comando: $comando");
                  _webSocketControlador.enviarComando(comando);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _actualizarComando(comando);
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "X: ${event.x.toStringAsFixed(2)}\n"
                            "Y: ${event.y.toStringAsFixed(2)}\n"
                            "Z: ${event.z.toStringAsFixed(2)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Comando Actual: $comandoActual",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calibrarGiroscopio,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                "Calibrar Giroscopio",
                style: TextStyle(fontSize: 16,color: Colors.white,),
                
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  String determinarComando(double x, double y, double z) {
    if (x > 2) {
      return "abrir_word";
    } else if (y > 2) {
      return "abrir_excel";
    } else if (z > 2) {
      return "abrir_navegador";
    }
    return "";
  }
}
