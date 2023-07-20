import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String kAppTitle = 'Windows Printer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _HomePage(title: kAppTitle),
    );
  }
}

extension DoubleExt on double {
  double get toDpi => this * 8.0;
}

class _HomePage extends StatelessWidget {
  const _HomePage({required String title}) : _title = title;

  final String _title;

  Future<void> _printWithPrinting() async {
    const kTicketWidth = 55;
    const kTicketHeight = 29;

    final document = pw.Document();
    final imageToDoc = await imageFromAssetBundle('assets/etiquette_test.png');
    const kPageFormat = PdfPageFormat(
      kTicketWidth * PdfPageFormat.mm,
      kTicketHeight * PdfPageFormat.mm,
    );

    document.addPage(
      pw.Page(
        pageFormat: kPageFormat,
        build: (_) {
          return pw.Center(
            child: pw.Image(
              imageToDoc,
              fit: pw.BoxFit.fill,
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => document.save(),
      name: 'CHR_Test_Windows',
      format: kPageFormat,
      usePrinterSettings: true,
    );

    //await Printing.layoutPdf(
    //  onLayout: (format) async {
    //    final page = await Printing.raster(
    //      await document.save(),
    //      pages: <int>[0],
    //      dpi: PdfPageFormat.inch.toDpi,
    //    ).first;
    //
    //    return page.toPng();
    //  },
    //  name: 'CHR_Test_Windows',
    //  format: kPageFormat,
    //  usePrinterSettings: true,
    //);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _printWithPrinting,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
