import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de QR Codes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const QRCodeCounterScreen(),
      },
    );
  }
}

class QRCodeCounterScreen extends StatefulWidget {
  const QRCodeCounterScreen({super.key});

  @override
  State<QRCodeCounterScreen> createState() => _QRCodeCounterScreenState();
}

class _QRCodeCounterScreenState extends State<QRCodeCounterScreen> {
  int _total = 0;
  bool _isScanning = true;
  DateTime? _lastScanTime;

  // Function to handle QR code detection
  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      final DateTime now = DateTime.now();
      // Simple debounce to prevent counting the same code 60 times per second
      // Allowing a scan every 500ms to mimic the "fps: 10" behavior but slightly more controlled
      if (_lastScanTime == null || now.difference(_lastScanTime!) > const Duration(milliseconds: 500)) {
        setState(() {
          _total++;
          _lastScanTime = now;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador de QR Codes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // Camera View
            Container(
              width: 300,
              height: 300,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MobileScanner(
                  onDetect: _onDetect,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Total lido:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$_total',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _total = 0;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Zerar Contador'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
