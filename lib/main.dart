import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ruunr/all_runs.dart';
import 'package:ruunr/models/runs.dart';
import 'package:ruunr/ruunr_icons.dart';
import 'package:ruunr/screens/home_screen.dart';
import 'package:ruunr/screens/map_tracking_screen.dart';
import 'package:ruunr/screens/monthly_runs_detail_screen.dart';
import 'package:ruunr/screens/runs_data_detail_screen.dart';
import 'package:ruunr/screens/runs_edit_screen.dart';
import 'package:ruunr/screens/runs_all_screen.dart';
import 'package:ruunr/screens/settings_screen.dart';
import 'package:ruunr/screens/signin_screen.dart';
import 'package:ruunr/screens/stats_screen.dart';
import 'package:ruunr/screens/stopwatch_save_screen.dart';
import 'package:ruunr/screens/stopwatch_screen.dart';
import 'package:ruunr/services/firestore_service.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false;

    initializeFirebase() async {
      // await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null){
          isLoggedIn = false;
        } else {
          isLoggedIn = true;
        }
      });
    }

    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AllRunsData>(create: (context) { return AllRunsData(); } ),
            ChangeNotifierProvider<FirestoreService>(create: (context) { return FirestoreService(); } ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: const MaterialColor(0xff343A40, <int, Color>{
                50: Color(0xffF8F9FA),
                100: Color(0xffE9ECEF),
                200: Color(0xffDEE2E6),
                300: Color(0xffCED4DA),
                400: Color(0xffADB5BD),
                500: Color(0xff6C757D),
                600: Color(0xff343A40),
                700: Color(0xff212529)
              }),
              fontFamily: "Poppins",
              scaffoldBackgroundColor: const Color(0xff212529),
              colorScheme: const ColorScheme.dark(primary: Color(0xffF8F9FA), secondary: Color(0xffE9ECEF)), //Set text to white
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xff212529), elevation: 0, toolbarHeight: 80, titleTextStyle: TextStyle(fontSize: 48, fontWeight: FontWeight.w700, fontFamily: "Poppins", color: Color(0xff6C757D))) //set appbar color and remove shadow (elevation)
            ),
            home: !isLoggedIn ? SignInScreen() : MainScreen(),
            routes: {
              SignInScreen.routeName: (context) => SignInScreen(),
              SignUpScreen.routeName: (context) => SignUpScreen(),
              LogInScreen.routeName: (context) => LogInScreen(),
              
              SaveStopwatchScreen.routeName: (context) => SaveStopwatchScreen(),
              RunDataDetailScreen.routeName: (context) => RunDataDetailScreen(),
              MonthlyRunDetailScreen.routeName: (context) => MonthlyRunDetailScreen(),
              EditRunsScreen.routeName: (context) => EditRunsScreen(),
              RunsScreen.routeName: (context) => RunsScreen(),
              MainScreen.routeName: (context) => MainScreen(),

              MapTrackingScreen.routeName: (context) => MapTrackingScreen(),
        
              // HomeScreen.routeName: (context) => HomeScreen(),
              // StopwatchScreen.routeName: (context) => StopwatchScreen(),
              // StatsScreen.routeName: (context) => StatsScreen(),
              // SettingsScreen.routeName: (context) => SettingsScreen(),
            },
          ),
        );
      }
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = "/main";  
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Stream<List<Runs>> runStream;
  int selectedIndex = 0;  

  @override
  void initState() {
    super.initState();

    runStream = FirestoreService().getRuns();
  }
  
  changePage(int i) {
    switch (i) {
      case 0:
        return HomeScreen();
      case 1:
        return const StopwatchScreen();
      case 2:
        return StatsScreen();
      case 3:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Runs>>(
        stream: runStream, //magic by https://youtu.be/g8Y1Eqa4pbc
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return changePage(selectedIndex);
          }
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(RuunrIcon.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.clock), label: "Stopwatch"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.stats), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.gear), label: "Settings"),
        ],
        selectedItemColor: const Color(0xffE9ECEF),
        unselectedItemColor: const Color(0xff6C757D),
        selectedFontSize: 0, //This is label's font size
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: const Color(0xff212529),
        elevation: 0,
        currentIndex: selectedIndex,
        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
      ),
    );
  }
}

class NaviBar extends StatelessWidget {
  const NaviBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(RuunrIcon.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.clock), label: "Stopwatch"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.stats), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(RuunrIcon.gear), label: "Settings"),
        ],
        selectedItemColor: const Color(0xffE9ECEF),
        unselectedItemColor: const Color(0xff6C757D),
        selectedFontSize: 0, //This is label's font size
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: const Color(0xff212529),
        elevation: 0,
        currentIndex: selectedIndex,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, StopwatchScreen.routeName);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, StatsScreen.routeName);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, SettingsScreen.routeName);
              break;
          }
        },
      );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
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
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
