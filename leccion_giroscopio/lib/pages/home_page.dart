import 'package:flutter/material.dart';
import 'giroscopio_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control Computador"),
        backgroundColor: Colors.blue, // Color personalizado para la barra de navegación
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Color del botón
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding para el botón
            textStyle: const TextStyle(fontSize: 18), // Estilo de texto
          ),
          child: const Text("Ir al Control de Giroscopio"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GiroscopioPage()),
            );
          },
        ),
      ),
    );
  }
}
