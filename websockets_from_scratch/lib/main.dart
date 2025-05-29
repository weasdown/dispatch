import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'api.dart';
import 'utils.dart';
import 'websocket_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(apiClient: WebSocketApiClient()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.apiClient});

  final WebSocketApiClient apiClient;

  // final Uri _channelUri = Uri(scheme: 'ws', host: 'localhost', port: 8080);

  final Duration connectionTimeout = Duration(seconds: 20);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel? _channel;

  // Future<WebSocketChannel> connect() async {
  //   final WebSocketChannel channel = WebSocketChannel.connect(
  //     widget.apiClient.channelUri,
  //   );
  //   _channel = channel;
  //
  //   await channel.ready;
  //
  //   return channel;
  // }

  @override
  Widget build(BuildContext context) {
    _channel = widget.apiClient.channel;

    return Scaffold(
      appBar: AppBar(title: Text('WebSocket example')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: FutureBuilder<WebSocketChannel>(
            future: widget.apiClient.connect(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  _channel = snapshot.data as WebSocketChannel;

                  return WebsocketUi(channel: _channel!);
                } else {
                  return Column(
                    children: [
                      errorText(context, snapshot),
                      SizedBox(height: 30),
                      refreshButton(onPressed: () => setState(() {})),
                    ],
                  );
                }
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connecting to WebSocketChannel...',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 50),
                    CircularProgressIndicator(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
