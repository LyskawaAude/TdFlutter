class Question {
    int id = 0;
    String content = '';
    String rightAnswer = '';
    List<String> propositions = [];

    Question(int id, String content, String rightAnswer, List<String> propositions) {
        this.id = id;
        this.content = content;
        this.rightAnswer = rightAnswer;
        this.propositions = propositions;
    }
}

