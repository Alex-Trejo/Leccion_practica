class Comando {
  final String nombre;
  final String descripcion;

  // Constructor
  Comando({required this.nombre, required this.descripcion});

  // Método para convertir el objeto a un mapa (útil para la serialización a JSON)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  // Método para crear una instancia desde un mapa (útil para deserialización desde JSON)
  factory Comando.fromJson(Map<String, dynamic> json) {
    return Comando(
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
    );
  }
}
