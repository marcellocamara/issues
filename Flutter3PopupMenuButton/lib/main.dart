import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 3.27.2 PopupMenuButton Issue',
      home: const MyHomePage(title: 'PopupMenuButton Issue'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        key: UniqueKey(), // Bug here - removing key works
        child: PopupMenuButton(
          tooltip: 'Options',
          icon: const Icon(
            Icons.bug_report_outlined,
          ),
          onSelected: (value) async {
            switch (value) {
              case 'option1':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SecondPage(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (_) {
            FocusScope.of(context).focusedChild?.unfocus();
            return [
              PopupMenuItem(
                value: 'option1',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Icon(Icons.bug_report_outlined),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'Open Second Page',
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
    );
  }
}
