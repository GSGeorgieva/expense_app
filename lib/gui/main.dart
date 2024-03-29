library main.dart;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:project1/entity.dart' as ent;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'notifications.dart';

part 'add_expense.dart';
part '../utilities/default_category.dart';
part 'authentication.dart';
part 'categories_list.dart';
part 'currency_page.dart';
part 'elements/drawer.dart';
part 'home.dart';
part 'add_category.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}
