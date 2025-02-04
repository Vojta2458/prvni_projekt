import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tankování paliva',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TankovaniScreen(),
    );
  }
}

class TankovaniScreen extends StatefulWidget {
  @override
  _TankovaniScreenState createState() => _TankovaniScreenState();
}

class _TankovaniScreenState extends State<TankovaniScreen> {
  final TextEditingController _datumController = TextEditingController();
  final TextEditingController _tachometrController = TextEditingController();
  final TextEditingController _palivoController = TextEditingController();
  final TextEditingController _cenaController = TextEditingController();
  final TextEditingController _poznamkyController = TextEditingController();

  DateTime _datum = DateTime.now();
  String _vysledek = ""; // Pro výsledek výpočtu spotřeby

  // Funkce pro výpočet spotřeby
  void _vypocitatSpotrebu() {
    final double palivo = double.tryParse(_palivoController.text) ?? 0;
    final double tachometr = double.tryParse(_tachometrController.text) ?? 0;
    final double cena = double.tryParse(_cenaController.text) ?? 0;

    // Pokud máme správné hodnoty
    if (palivo > 0 && tachometr > 0 && cena > 0) {
      double spotreba = (palivo / tachometr) * 100;
      setState(() {
        _vysledek = "Spotřeba: ${spotreba.toStringAsFixed(2)} l/100 km";
      });
    } else {
      setState(() {
        _vysledek = "Zadejte platné hodnoty!";
      });
    }
  }

  // Funkce pro výběr data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _datum,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _datum) {
      setState(() {
        _datum = picked;
        _datumController.text = '${_datum.day.toString().padLeft(2, '0')}.${_datum.month.toString().padLeft(2, '0')}.${_datum.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tankování paliva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Datum
            TextField(
              controller: _datumController,
              decoration: InputDecoration(
                labelText: 'Datum',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            // Tachometr
            TextField(
              controller: _tachometrController,
              decoration: InputDecoration(
                labelText: 'Stav tachometru (km)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Palivo
            TextField(
              controller: _palivoController,
              decoration: InputDecoration(
                labelText: 'Množství paliva (l)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Cena
            TextField(
              controller: _cenaController,
              decoration: InputDecoration(
                labelText: 'Cena za litr (Kč)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            // Poznámky (volitelné)
            TextField(
              controller: _poznamkyController,
              decoration: InputDecoration(
                labelText: 'Poznámky (volitelné)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            // Tlačítko pro výpočet
            ElevatedButton(
              onPressed: _vypocitatSpotrebu,
              child: Text('Vypočítat spotřebu'),
            ),
            SizedBox(height: 32),
            // Výsledek
            Text(
              _vysledek,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
