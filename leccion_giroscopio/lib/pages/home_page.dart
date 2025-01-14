import 'package:flutter/material.dart';
import 'giroscopio_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.computer, color: Colors.white),
            const SizedBox(width: 10),
            const Text("Control Computador"),
          ],
        ),
        backgroundColor: Colors.indigo,
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.gesture,
                color: Colors.indigo,
                size: 50,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Control de Giroscopio",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.control_camera),
              label: const Text(
                "Ir al Control de Giroscopio",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GiroscopioPage()),
                );
              },
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.white, thickness: 1, indent: 40, endIndent: 40),
            const SizedBox(height: 10),
            const Text(
              "Desarrolladores:",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Silvia Ivón Añasco Rivadeneira\nSheylee Arielle Enriquez Hernandez\nYorman Javier Oña Gamarra\nAlex Fernando Trejo Duque",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
