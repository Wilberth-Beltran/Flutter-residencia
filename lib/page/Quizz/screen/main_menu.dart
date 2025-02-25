import 'package:flutter/material.dart';
import '../screen/quizz_screen.dart';
import '../ui/shared/color.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColor.pripmaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    backgroundColor: AppColor.pripmaryColor,
    body: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 48.0,
        horizontal: 12.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "QUIZZ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: RawMaterialButton(
                onPressed: () {
                  // Navegar a la pantalla del Quiz
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizzScreen(),
                    ),
                  );
                },
                shape: const StadiumBorder(),
                fillColor: AppColor.secondaryColor,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: Text(
                    "Comenzar el Quizz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
