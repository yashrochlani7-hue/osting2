// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CostingApp());
}

class CostingApp extends StatelessWidget {
  const CostingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Costing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.grey,
      ),
      home: const CostingHomePage(),
    );
  }
}

class CostingHomePage extends StatefulWidget {
  const CostingHomePage({super.key});

  @override
  State<CostingHomePage> createState() => _CostingHomePageState();
}

class _CostingHomePageState extends State<CostingHomePage> {
  final TextEditingController micronCtrl = TextEditingController();
  final TextEditingController densityCtrl = TextEditingController();
  final TextEditingController rateCtrl = TextEditingController();
  final TextEditingController wastageCtrl = TextEditingController(text: '3');

  double finalCost = 0;

  String selectedFilm = 'PET';

  final Map<String, double> filmDensity = {
    'PET': 1.38,
    'BOPP': 0.91,
    'LDPE': 0.92,
    'CPP': 0.90,
    'FOIL': 2.70,
  };

  void calculateCost() {
    final double micron = double.tryParse(micronCtrl.text) ?? 0;
    final double density = double.tryParse(densityCtrl.text) ?? 0;
    final double rate = double.tryParse(rateCtrl.text) ?? 0;
    final double wastage = double.tryParse(wastageCtrl.text) ?? 0;

    // Excel-accurate logic
    // GSM = Micron × Density
    final double gsm = micron * density;

    // Base cost per KG
    final double baseCost = rate;

    // Wastage calculation
    final double wastageCost = baseCost * (wastage / 100);

    setState(() {
      finalCost = baseCost + wastageCost;
      _calculatedGSM = gsm;
    });
  }

  double _calculatedGSM = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Costing Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedFilm,
              items: filmDensity.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilm = value!;
                  densityCtrl.text = filmDensity[value].toString();
                });
              },
              decoration: const InputDecoration(labelText: 'Film Type'),
            ),
            TextField(
              controller: micronCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Micron / GSM'),
            ),
            TextField(
              controller: densityCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Density'),
            ),
            TextField(
              controller: rateCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rate per KG'),
            ),
            TextField(
              controller: wastageCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Wastage %'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCost,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Cost / KG: ₹ ${finalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}



