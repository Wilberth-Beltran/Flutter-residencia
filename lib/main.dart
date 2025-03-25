import 'package:buenos_habitos/firebase_options.dart';
import 'package:buenos_habitos/page/Calendario/provider/event_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './page/login/verificadorlogin.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Residencia',
        themeMode: ThemeMode.system, // Detecta el modo oscuro del sistema
        
       // Tema Claro
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 176, 210, 236), // Fondo azul claro
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 116, 179, 220), // Barra superior azul
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 116, 179, 220), // Color para tema claro
          ),
        ),

        // Tema Oscuro
        darkTheme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 93, 162, 215), // Fondo azul oscuro
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 101, 186, 228), // Barra superior azul grisáceo
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 101, 186, 228), //  Color más oscuro para tema oscuro
          ),
        ),

        locale: const Locale('es'), // Fuerza el idioma español
        supportedLocales: const [Locale('es')], // Idiomas soportados
        
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SfGlobalLocalizations.delegate, // Soporte para Syncfusion
        ],

        home: const SplashScreen(),
      ),
    );
  }
}
