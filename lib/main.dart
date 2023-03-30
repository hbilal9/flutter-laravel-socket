import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  String _result = 'helo';

  void _incrementCounter() {
    setState(() {
      // ignore: avoid_print
      _initWebSocket();
      _counter++;
      print(_counter);
    });
  }

  // _initWebSocket() {
  //   var key = 'thisIsA1xicP0rTaLD3v310p3DByHBilalKhanY0safZai';
  //   final channel = IOWebSocketChannel.connect("wss://dashboard.tabletag.io/app?protocol=7&client=browser&key=$key");
  //   channel.sink.add(jsonEncode({
  //     "event": "pusher:subscribe",
  //     "data": {
  //       "channel": "customer-order-status-1",
  //     }
  //   }));

  //   channel.stream.listen((_data) {
  //     var data = json.decode(_data);
  //     print('event data: $data');
  //     if (data['data'] != null) {
  //       var eventData = json.decode(data['data']);
  //       if (eventData['socket_id'] == null) {
  //         print(eventData);
  //       }
  //     }
  //   }, onError: (error) {
  //     // ignore: avoid_print
  //     print("Socket: error => " + error.toString());
  //   }, onDone: () {
  //     // ignore: avoid_print
  //     print("Socket: done");
  //   });
  // }

  _initWebSocket() async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Internet connection is available
        var key = 'thisIsA1xicP0rTaLD3v310p3DByHBilalKhanY0safZai';
        var uri = Uri.parse("wss://dashboard.tabletag.io:443/app/$key");
        final channel = IOWebSocketChannel.connect(uri);
        channel.sink.add(jsonEncode({
          "event": "pusher:subscribe",
          "data": {
            "channel": "customer-reservation-status-1",
          }
        }));

        channel.stream.listen((_data) {
          var data = json.decode(_data);
          print('event data: $data');
          if (data['data'] != null) {
            var eventData = json.decode(data['data']);
            if (eventData['socket_id'] == null) {
              print(eventData);
              _result = eventData;
            }
          }
        }, onError: (error) {
          // ignore: avoid_print
          print("Socket: error => " + error.toString());
          _result = error.toString();
        }, onDone: () {
          // ignore: avoid_print
          print("Socket: done");
        });
      }
    } on SocketException catch (_) {
      // Internet connection is not available
      print('Internet connection is not available');
    }
  }
   @override
  void initState() {
    super.initState();
    _initWebSocket();
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$_result',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
