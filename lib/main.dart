import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/health_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>HealthProvider(),

        )
      ],
      child: MaterialApp(
        title: 'Flutter Health Demo Page',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    HealthProvider healthProvider = Provider.of<HealthProvider>(context);


    return Scaffold(

      body: FutureBuilder<Map>(
        future: healthProvider.getAllHealthData(),
        builder: (context, snap){
          if (snap.hasData){
            final Map healthData = snap.data;
            final List healthDataKeys  = healthData.keys.toList();

            return ListView.builder(
              itemCount: healthDataKeys.length,
              itemBuilder: (context, index){
                final healthDataItem = healthData[healthDataKeys[index]];

                return ListTile(
                  title: Text(healthDataKeys[index]),
                  subtitle: Text(healthDataItem.toString()),
                );
              },
            );
          }else if (snap.hasError){
            return Center(child: Text("Encountered Error ${snap.error}"));
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}
