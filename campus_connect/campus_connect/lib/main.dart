import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/notification_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/event_viewmodel.dart';
import 'viewmodels/quote_viewmodel.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';


void main() async {
    await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  runApp(MyApp());
}


class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        ChangeNotifierProvider(create: (_) => QuoteViewModel()..loadRandomQuote()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) => MaterialApp(
          title: 'Campus Connect',
          theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
          themeMode: themeNotifier.themeMode,
          home: AuthGate(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVm, _) {
        if (authVm.isInitializing) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return authVm.user == null ? LoginScreen() : HomeScreen();
      },
    );
  }
}
