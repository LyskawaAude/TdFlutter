import 'package:flutter/material.dart';
import './models/question.dart';

void main() {
  runApp(const KGBapp());
}

class KGBapp extends StatelessWidget {
  const KGBapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KGB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuestionsPage(),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});
  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {

 List<Question> questionsList = []; 

  @override
  void initState() {
    questionsList.add(Question (1, "Question 1", '1', ['1', '2', '3', '4']));
    questionsList.add(Question (2, "Question 2", '2', ['1', '2', '3', '4']));
    questionsList.add(Question (3, "Question 3", '2', ['1', '2', '3', '4']));
    questionsList.add(Question (4, "Question 4", '2', ['1', '2', '3', '4']));
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('KGB'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: questionsList.length,
        itemBuilder: (context, i) {
          return ListTile(
              title: Text(questionsList[i].content)
          );
        }
      ),
    );
  }
}
