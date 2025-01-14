class GiroscopioFiltro {
  static const int _ventana = 5; // Tamaño de la ventana para la media móvil
  final List<double> _valoresX = [];
  final List<double> _valoresY = [];
  final List<double> _valoresZ = [];

  double _promedio(List<double> valores) {
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  Map<String, double> filtrar(double x, double y, double z) {
    if (_valoresX.length >= _ventana) {
      _valoresX.removeAt(0);
      _valoresY.removeAt(0);
      _valoresZ.removeAt(0);
    }

    _valoresX.add(x);
    _valoresY.add(y);
    _valoresZ.add(z);

    return {
      "x": _promedio(_valoresX),
      "y": _promedio(_valoresY),
      "z": _promedio(_valoresZ),
    };
  }
}
