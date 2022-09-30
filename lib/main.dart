import 'package:flutter/material.dart';
import './models/question.dart';
import 'dart:developer';

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

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key, required this.question});

  final Question question; 
  
  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late Question question = widget.question;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? valeur = '';
  bool _isButtonDisabled = true;
  int _score = 0;

  void _validate() {
    if (_formKey.currentState!.validate()) {
      if(valeur == '') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: const Text("Merci de mettre un réponse"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Text("Fermer"),
                ),
              ),
            ],
          ),
        );
        setState((){
          _isButtonDisabled = true;
        });
      } else if(valeur == question.rightAnswer) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bonne réponse')),
        );
        setState((){
          _isButtonDisabled = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mauvaise réponse')),
        );
        setState((){
          _isButtonDisabled = false;
        });
      }
    }
  }
        


  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    question.propositions.forEach((propositions) {
      children.add(RadioListTile(
        title: Text(propositions),
        value: propositions,
        groupValue: valeur,
        onChanged: (value) {
          setState((){
            valeur = propositions;
          });
        } 
      ));
      print(_score);
    });
    children.insert(0, Text(question.content));
    children.add(
      ElevatedButton(
        child: const Text('Submit'),
        onPressed: _isButtonDisabled ? ()  {
          _validate();
        } : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
      
      ),
    );
    return Form(
      key : _formKey, 
      child: Column(children : children), 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('KGB'),
      ),
      body : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: questionsList.length,
        itemBuilder: (context, i) {
          return QuestionWidget(question : questionsList[i]);
        }
      ),
    );
  }
}