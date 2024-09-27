import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConversionApp());
}

class TemperatureConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50], // Background color
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87), // Default text color
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black54,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Default text color in dark mode
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch theme based on system settings
      home: TemperatureConversionPage(),
    );
  }
}

class TemperatureConversionPage extends StatefulWidget {
  @override
  _TemperatureConversionPageState createState() => _TemperatureConversionPageState();
}

class _TemperatureConversionPageState extends State<TemperatureConversionPage> {
  String _selectedConversion = 'F to C';
  double _inputValue = 0.0;
  String _result = '';
  List<String> _history = [];
  String _errorMessage = '';

  void _convertTemperature() {
    if (_inputValue == 0.0) {
      setState(() {
        _errorMessage = 'Please enter a valid temperature';
      });
      return;
    }

    double convertedValue;
    if (_selectedConversion == 'F to C') {
      convertedValue = (_inputValue - 32) * 5 / 9;
      _result = '${convertedValue.toStringAsFixed(2)} °C';
      _history.add('F to C: $_inputValue => $_result');
    } else {
      convertedValue = _inputValue * 9 / 5 + 32;
      _result = '${convertedValue.toStringAsFixed(2)} °F';
      _history.add('C to F: $_inputValue => $_result');
    }
    setState(() {
      _errorMessage = '';
    });
  }

  void _resetFields() {
    setState(() {
      _inputValue = 0.0;
      _result = '';
      _history.clear();
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Conversion'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Conversion Type:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
            ),
            ListTile(
              title: const Text('Fahrenheit to Celsius', style: TextStyle(fontSize: 18)),
              leading: Radio<String>(
                value: 'F to C',
                groupValue: _selectedConversion,
                onChanged: (value) {
                  setState(() {
                    _selectedConversion = value!;
                    _errorMessage = ''; // Clear error message on conversion change
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Celsius to Fahrenheit', style: TextStyle(fontSize: 18)),
              leading: Radio<String>(
                value: 'C to F',
                groupValue: _selectedConversion,
                onChanged: (value) {
                  setState(() {
                    _selectedConversion = value!;
                    _errorMessage = ''; // Clear error message on conversion change
                  });
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Temperature',
                labelStyle: TextStyle(color: Colors.blueAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _inputValue = double.tryParse(value) ?? 0.0;
                setState(() {
                  _errorMessage = ''; // Clear error message on valid input
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _convertTemperature,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Convert', style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: _resetFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Reset button color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Reset', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty) // Show error message if any
              Text(_errorMessage, style: TextStyle(fontSize: 16, color: Colors.red)),
            if (_result.isNotEmpty) // Show result if available
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Result: $_result',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Text('History:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey[700])),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _history[index],
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    tileColor: Colors.white, // List item background
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
