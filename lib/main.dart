import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/link.dart';
import 'dart:convert';

void main() {
  runApp(QRCodeApp());
}

class QRCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      home: QRCode(),
    );
  }
}

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String scannedCode = ''; // Variable to hold the scanned code
  String rawBytes = ''; // Variable to hold the raw bytes

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedCode = scanData.code!;
        rawBytes = base64Encode(scanData.rawBytes ?? []);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 350,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Place the QR code inside the frame',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 8,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      children: [
                        const Expanded(
                          child: Text(
                            'Scanned code:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: Link(
                            target: LinkTarget.blank,
                            uri: Uri.tryParse(scannedCode) ?? Uri(),
                            builder: (context, followLink) => TextButton(
                              child: Text(
                                scannedCode,
                                style: const TextStyle(fontSize: 17),
                              ),
                              onPressed: followLink,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Raw bytes (Base64):',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              rawBytes,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
