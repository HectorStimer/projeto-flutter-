import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final data = capture.barcodes.first.rawValue;
    if (data == null) return;

    try {
      final decoded = jsonDecode(data);

      Navigator.pop(context, decoded); // Retorna dados para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QR Code inválido!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR")),
      body: MobileScanner(
        onDetect: (capture) => _onDetect(context, capture),
      ),
    );
  }
}
