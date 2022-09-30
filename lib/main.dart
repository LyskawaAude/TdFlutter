import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/question.dart';

void main() {
  runApp(const KGBapp());
}

class KGBapp extends StatelessWidget {
  const KGBapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: MaterialApp(
        title: 'KGB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const QuestionsPage(),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({super.key, required this.question});

  final Question question; 
  
  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class CounterProvider  extends ChangeNotifier {
  int _countVal = 0;
  int _questionIndex = 0;

  int get countVal => _countVal;
  int get questionIndex => _questionIndex;

  void add() {
    _countVal++;
  }
  void addQuestionIndex(){
    _questionIndex++;
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late Question question = widget.question;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? valeur = '';
  bool _isButtonDisabled = true;


  void _validate() {
    if (_formKey.currentState!.validate()) {
      var index = Provider.of<CounterProvider>(context, listen: false);
      index.addQuestionIndex();
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
        var score = Provider.of<CounterProvider>(context, listen: false);
        score.add();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bonne réponse'),
          backgroundColor: Colors.green),
        );
        setState((){
          _isButtonDisabled = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mauvaise réponse'),
          backgroundColor: Colors.red),
        );
        setState((){
          _isButtonDisabled = false;
        });
      }
      if(index._questionIndex == 4){
        var score = Provider.of<CounterProvider>(context, listen: false);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Résultat'),
            content: Text('Ton score : ${score._countVal}'),
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
    questionsList.add(Question (1, "Quelle est la devise de l'Union européenne ?", 'Unis dans la diversité', ['Un pour tous, tous pour un', 'Liberté, égalité, fraternité', 'Unis dans la diversité', 'L\'union fait la force']));
    questionsList.add(Question (2, "Le saturnisme est une maladie due à une intoxication au :", 'Plomb', ['Plomb', 'Fer', 'Cuivre', 'Aluminium']));
    questionsList.add(Question (3, "Quelle ville française n'est pas située sur le Rhône ?", 'Grenoble', ['Avignon', 'Grenoble', 'Lyon', 'Vienne']));
    questionsList.add(Question (4, "Lequel de ces fleuves ne coule pas en Russie ?", 'La Vistule', ['La Volga', 'L\'Ienisseï', 'L\'Ob', 'La Vistule']));
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
