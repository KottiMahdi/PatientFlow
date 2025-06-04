import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:management_cabinet_medical_mobile/pages/appointement/appointement_page.dart';
import 'package:management_cabinet_medical_mobile/pages/auth/forgot_password_page.dart';
import 'package:management_cabinet_medical_mobile/pages/auth/inscription_page.dart';
import 'package:management_cabinet_medical_mobile/pages/auth/login_page.dart';
import 'package:management_cabinet_medical_mobile/pages/navigation_bar.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/add_patient_page.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/patients_page.dart';
import 'package:management_cabinet_medical_mobile/providers/appointement_provider.dart';
import 'package:management_cabinet_medical_mobile/providers/patient_provider.dart';
import 'package:management_cabinet_medical_mobile/providers/track_patient_provider.dart';
import 'package:management_cabinet_medical_mobile/providers/profile_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Try to initialize with a specific name
    await Firebase.initializeApp(
      name: 'MedicalCabinetApp',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // If that fails, get the existing instance
    Firebase.app('MedicalCabinetApp');
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PatientProvider()),
      ChangeNotifierProvider(create: (_) => PatientProviderGlobal()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ],
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? MedicalLoginPage() : navigationBar(),
      routes: {
        '/patients': (context) => PatientsPage(),
        '/addPatient': (context) => AddPatientPage(),
        //'/editPatient': (context) => EditPatientPage()
        'signup': (context) => MedicalSignUpPage(),
        'login': (context) => MedicalLoginPage(),
        'forgotPWD': (context) => ForgotPasswordPage(),
        'navigationBar': (context) => navigationBar(),
        'appointment' : (context) => AppointmentPage()
      },
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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
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
