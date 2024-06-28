import 'package:flutter/material.dart';
import 'package:event_beacon/event_beacon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventBeacon Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'EventBeacon Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EventBeacon _beacon = EventBeacon();
  String _lastMessage = 'No message received';

  @override
  void initState() {
    super.initState();
    _beacon.on<String>((message) {
      setState(() {
        _lastMessage = message;
      });
    });
  }

  @override
  void dispose() {
    _beacon.dispose();
    super.dispose();
  }

  void _emitMessage() {
    _beacon.emit('Hello from EventBeacon! ${DateTime.now()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Last received message:',
            ),
            Text(
              _lastMessage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _emitMessage,
        tooltip: 'Emit Message',
        child: const Icon(Icons.send),
      ),
    );
  }
}
