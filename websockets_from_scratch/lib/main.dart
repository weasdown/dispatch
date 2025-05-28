import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Future future = Future.delayed(Duration(seconds: 2), () => true);

    return Scaffold(
      appBar: AppBar(title: Text('MyHomePage')),
      body: Center(
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return switch (snapshot.connectionState) {
              ConnectionState.done =>
                (snapshot.hasData)
                    ? Text(snapshot.data.toString())
                    : Text(snapshot.error.toString()),
              _ => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 50),
                  CircularProgressIndicator(),
                ],
              ),
            };
          },
        ),
      ),
    );
  }
}
