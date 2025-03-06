import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uberbagar/screens/home/home_screen.dart';
import 'package:uberbagar/screens/fighters/fighters_screen.dart';
import 'package:uberbagar/screens/profile/profile_screen.dart';
import 'package:uberbagar/widgets/bottom_nav_bar.dart';

const supabaseUrl = 'https://fjxnupldmroaqgakzaxj.supabase.co';
var supabaseKey = dotenv.get('SUPABASE_ANON_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  MapboxOptions.setAccessToken(dotenv.get('SECRET_KEY'));

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fighters App',
      initialRoute: '/',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FightersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}