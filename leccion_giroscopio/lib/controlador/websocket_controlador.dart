import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

class WebSocketControlador {
  final String url;
  late WebSocketChannel _channel;

  WebSocketControlador(this.url) {
    _conectar();
  }

  // Método para establecer la conexión WebSocket
  void _conectar() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      debugPrint("Conexión WebSocket establecida con $url.");
    } catch (e) {
      debugPrint("Error al conectar con el WebSocket: $e");
    }
  }

  // Método para enviar comandos a través del WebSocket
  void enviarComando(String comando) {
    try {
      if (_channel.closeCode == null) { // Verifica si la conexión está cerrada
        debugPrint("Intentando enviar comando: $comando");
        _channel.sink.add(comando);
        debugPrint("Comando enviado: $comando");
      } else {
        debugPrint("La conexión WebSocket está cerrada.");
      }
    } catch (e) {
      debugPrint("Error al enviar comando: $e");
    }
  }

  // Método para cerrar la conexión WebSocket
  void cerrarConexion() {
    try {
      _channel.sink.close();
      debugPrint("Conexión WebSocket cerrada.");
    } catch (e) {
      debugPrint("Error al cerrar WebSocket: $e");
    }
  }

  // Método para escuchar los mensajes del WebSocket
  Stream<dynamic> obtenerMensajes() {
    return _channel.stream;
  }

  // Método para asegurarse de cerrar la conexión al destruir el objeto
  void dispose() {
    try {
      _channel.sink.close();
      debugPrint("Conexión WebSocket cerrada en dispose.");
    } catch (e) {
      debugPrint("Error al cerrar WebSocket en dispose: $e");
    }
  }
}
