import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Excel Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  bool? error;
  String errorDescription = '';

  Future<void> fetchFromAsset() async {
    try {
      setState(() => loading = true);

      ByteData data = await rootBundle.load('assets/xlsx/MILIONARIA.xlsx');
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      mountExcelAndPrint(bytes);

      setState(() {
        error = false;
        loading = false;
      });
    } catch (_) {
      setState(() {
        loading = false;
        error = true;
        errorDescription = _.toString();
      });
    }
  }

  Future<void> fetchFromUrl() async {
    try {
      setState(() => loading = true);

      final response = await get(
        Uri.parse(
          'https://servicebus2.caixa.gov.br/portaldeloterias/api/resultados/download?modalidade=Mais-Milionaria',
        ),
      ).timeout(const Duration(seconds: 5));

      mountExcelAndPrint(response.bodyBytes);

      setState(() {
        error = false;
        loading = false;
      });
    } catch (_) {
      setState(() {
        loading = false;
        error = true;
        errorDescription = _.toString();
      });
    }
  }

  void mountExcelAndPrint(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    for (final table in excel.tables.keys) {
      debugPrint(table);
      debugPrint(excel.tables[table]?.maxColumns.toString());
      debugPrint(excel.tables[table]?.maxRows.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Fetch Xlsx from:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlinedButton(
                  onPressed: loading ? null : fetchFromUrl,
                  child: const Text('Url'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: loading ? null : fetchFromAsset,
                  child: const Text('Asset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              error == null
                  ? 'Choose an option'
                  : error!
                      ? 'Error: $errorDescription'
                      : 'Success',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
