import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp3/model/job.dart';
import 'package:tp3/page/job_page.dart';
import 'package:animate_do/animate_do.dart';

Future <void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(JobAdapter());
  await Hive.openBox<Job>('job');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Calcul du salaire brut en Net';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.red),
    home: JobPage(),
  );
}
