import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'result_screen.dart';
import '../ui/shared/color.dart';

class QuestionModel {
  final String question;
  final Map<String, bool> answers;

  QuestionModel({required this.question, required this.answers});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json["question"],
      answers: Map<String, bool>.from(json["answers"]),
    );
  }
}

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({Key? key}) : super(key: key);

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Siguiente Pregunta";
  bool answered = false;
  List<QuestionModel> questions = [];
  bool isLoading = true; // Variable para mostrar el loader mientras se cargan las preguntas

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    fetchQuestions(); // Cargar preguntas desde Firebase
  }

  /// **📌 Función para obtener preguntas desde Firebase**
Future<void> fetchQuestions() async {
  const String apiUrl =
      "https://residencia-8def7-default-rtdb.firebaseio.com/preguntas.json";
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      List<QuestionModel> loadedQuestions = [];

      // **Filtrar solo las preguntas que tienen "question" y "answers"**
      data.forEach((key, value) {
        if (value is Map<String, dynamic> &&
            value.containsKey("question") &&
            value.containsKey("answers")) {
          loadedQuestions.add(QuestionModel.fromJson(value));
        }
      });

      // **Aleatorizar las preguntas y seleccionar 10**
      loadedQuestions.shuffle(Random()); // Mezcla las preguntas
      loadedQuestions = loadedQuestions.take(10).toList(); // Tomar solo 10

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } else {
      throw Exception("Error al cargar preguntas");
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.pripmaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColor.pripmaryColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // **Mostrar loader mientras se cargan los datos**
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: PageView.builder(
                controller: _controller!,
                onPageChanged: (page) {
                  if (page == questions.length - 1) {
                    setState(() {
                      btnText = "See Results";
                    });
                  }
                  setState(() {
                    answered = false;
                  });
                },
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "PREGUNTA ${index + 1}/${questions.length}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        height: 200.0,
                        child: Text(
                          questions[index].question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                      for (int i = 0; i < questions[index].answers.length; i++)
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            fillColor: btnPressed
                                ? questions[index].answers.values.toList()[i]
                                    ? Colors.green
                                    : Colors.red
                                : AppColor.secondaryColor,
                            onPressed: !answered
                                ? () {
                                    if (questions[index]
                                        .answers
                                        .values
                                        .toList()[i]) {
                                      score++;
                                    }
                                    setState(() {
                                      btnPressed = true;
                                      answered = true;
                                    });
                                  }
                                : null,
                            child: Text(
                              questions[index].answers.keys.toList()[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 40.0),
                      RawMaterialButton(
                        onPressed: () {
                          if (_controller!.page?.toInt() == questions.length - 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(score),
                              ),
                            );
                          } else {
                            _controller!.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInExpo,
                            );
                            setState(() {
                              btnPressed = false;
                            });
                          }
                        },
                        shape: const StadiumBorder(),
                        fillColor: Colors.blue,
                        padding: const EdgeInsets.all(18.0),
                        elevation: 0.0,
                        child: Text(
                          btnText,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  );
                },
                itemCount: questions.length,
              ),
            ),
    );
  }
}

