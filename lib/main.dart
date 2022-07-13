import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MethodChannel methodChannel =
      const MethodChannel("com.example.flutter_channel_test/testChannel");
  late Stream<int> stream;

  @override
  void initState() {
    super.initState();
    stream =
        const EventChannel("com.example.flutter_channel_test/testEventChannel")
            .receiveBroadcastStream()
            .distinct()
            .map((event) => event as int);
  }

  void _invokeMethodChannel() {
    methodChannel.invokeMethod("testAction");
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Stream<int>>(
      create: (_) => stream,
      builder: (context, widget) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Event Channel Demo"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                // TitleWidget(),
                DisplayEventWidget(title: "Widget 1"),
                DisplayEventWidget(title: "Widget 2"),
                DisplayEventWidget(title: "Widget 3"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _invokeMethodChannel,
            child: const Icon(Icons.send),
          ),
        );
      },
    );
  }
}

class DisplayEventWidget extends StatelessWidget {
  final String title;

  const DisplayEventWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: "No Data",
      stream: context.read<Stream<int>>(),
      builder: (context, snapshot) {
        return Text(
          title + " - " + snapshot.data.toString(),
          style: Theme.of(context).textTheme.subtitle1,
        );
      },
    );
  }
}
