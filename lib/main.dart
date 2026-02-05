import 'package:flutter/material.dart';

void main() => runApp(const PorcentajeApp());

class PorcentajeApp extends StatelessWidget {
  const PorcentajeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PorcentajeHome(),
    );
  }
}

class PorcentajeHome extends StatefulWidget {
  const PorcentajeHome({super.key});

  @override
  State<PorcentajeHome> createState() => _PorcentajeHomeState();
}

class _PorcentajeHomeState extends State<PorcentajeHome> {
  final _montoCtrl = TextEditingController();
  final _porcCtrl = TextEditingController();

  double? _resultado;
  String? _error;

  double? _parse(String text) {
    // Permite "12.5" o "12,5"
    final clean = text.trim().replaceAll(',', '.');
    return double.tryParse(clean);
  }

  void _calcular() {
    final monto = _parse(_montoCtrl.text);
    final porc = _parse(_porcCtrl.text);

    setState(() {
      _error = null;
      _resultado = null;

      if (monto == null || porc == null) {
        _error = "Ingresa números válidos (ej: 25000 y 15).";
        return;
      }
      if (monto < 0 || porc < 0) {
        _error = "Nada de negativos. No estamos en economía creativa.";
        return;
      }

      _resultado = monto * (porc / 100.0);
    });
  }

  void _limpiar() {
    setState(() {
      _montoCtrl.clear();
      _porcCtrl.clear();
      _resultado = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _porcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultadoTxt = _resultado == null
        ? "Resultado: —"
        : "Resultado: ${_resultado!.toStringAsFixed(2)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de %"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _montoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monto (ej: 25000)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _porcCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Porcentaje (ej: 15)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calcular,
                    child: const Text("Calcular"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limpiar,
                    child: const Text("Limpiar"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            Text(
              resultadoTxt,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ejemplo: Monto 100000 y % 12.5 → 12500",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

