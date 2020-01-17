import 'dart:math';

class BlackJackModel {
  int currentMove = 0;
  int future = 0;
  List<int> playerScores = [0];
  List<int> dealerScores = [0];
  List<String> playerCards = [];
  List<String> dealerCards = [];
  int winner = -1;
  int sequenceIndex = 0;
  int sequenceNo = 0;
  List<List<String>> winSequences = [
    ['3', '9', '5', '4'],
    ['10', '6', '5'],
    ['K', '7', '4'],
    ['Q', 'A']
  ];
  List<List<String>> loseSequences = [
    ['3', '5', '8', 'Q'],
    ['6', '8', '10'],
    ['K', '3', 'J'],
    ['Q', '5', '7']
  ];

  BlackJackModel(this.future);

  String generateCard() {
    List<dynamic> colors = ['C', 'D', 'H', 'S'];
    List<dynamic> numbers = [
      'A',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'K',
      'Q',
      'J'
    ];

    String str =
        '${colors[Random().nextInt(colors.length - 1)]}${numbers[Random().nextInt(numbers.length - 1)]}';
    return str;
  }

  void calculateScore(String card, int side) {
    print(card);
    List<int> scores = [];
    String number = card.substring(1);
    if (number == "A") {
      scores.add(1);
      scores.add(11);
    } else if (number == "K" || number == "J" || number == "Q") {
      scores.add(10);
    } else {
      scores.add(int.parse(number));
    }

    if (side == 0) {
      if (scores.length > 1) {
        if (playerScores.length > 1) {
          int minNo = playerScores.reduce(min);
          playerScores[0] = minNo + scores[0];
          playerScores[1] = minNo + scores[1];
        } else {
          int minNo = playerScores[0];
          playerScores[0] = minNo + scores[0];
          playerScores.add(minNo + scores[1]);
        }
      } else {
        if (playerScores.length > 1) {
          playerScores[0] += scores[0];
          playerScores[1] += scores[0];
        } else {
          playerScores[0] += scores[0];
        }
      }
    } else {
      if (scores.length > 1) {
        if (dealerScores.length > 1) {
          int minNo = dealerScores.reduce(min);
          dealerScores[0] = minNo + scores[0];
          dealerScores[1] = minNo + scores[1];
        } else {
          int minNo = dealerScores[0];
          dealerScores[0] = minNo + scores[0];
          dealerScores.add(minNo + scores[1]);
        }
      } else {
        if (dealerScores.length > 1) {
          dealerScores[0] += scores[0];
          dealerScores[1] += scores[0];
        } else {
          dealerScores[0] += scores[0];
        }
      }
    }
  }

  removeReduntant(side) {
    if (side == 0) {
      if (playerScores.length > 1) {
        if (playerScores[1] > 21) playerScores.removeLast();
      }
    } else {
      if (dealerScores.length > 1) {
        if (dealerScores[1] > 21) dealerScores.removeLast();
      }
    }
  }

  bool checkBust(side) {
    if (side == 0) {
      if (playerScores[0] > 21)
        return true;
      else
        return false;
    } else {
      if (dealerScores[0] > 21)
        return true;
      else
        return false;
    }
  }

  bool check21(side) {
    if (side == 0) {
      if (playerScores.reduce(max) == 21)
        return true;
      else
        return false;
    } else {
      if (dealerScores.reduce(max) == 21)
        return true;
      else
        return false;
    }
  }

  void checkWinner() {
    int playerScore = playerScores.reduce(max);
    int dealerScore = dealerScores.reduce(max);

    if (playerScore == dealerScore)
      winner = 2;
    else if (dealerScore > playerScore) winner = 1;
  }

  void addCard(String card, int side) {
    if (side == 0)
      playerCards.add(card);
    else
      dealerCards.add(card);
    calculateScore(card, side);
    removeReduntant(side);
    if (checkBust(side)) {
      winner = side == 0 ? 1 : 0;
      return;
    }
    if (check21(side)) {
      winner = side;
      return;
    }
    if (currentMove == 1) checkWinner();
  }

  String generateColor(String card) {
    List<dynamic> colors = ['C', 'D', 'H', 'S'];
    String str = '${colors[Random().nextInt(colors.length - 1)]}$card';
    return str;
  }

  void start() {
    if (future == 0) {
      addCard(generateCard(), 0);
      addCard(generateCard(), 0);
      addCard(generateCard(), 1);
    } else if (future == 1) {
      sequenceNo = Random().nextInt(winSequences.length - 1);
      addCard(generateColor(winSequences[sequenceNo][sequenceIndex++]), 0);
      addCard(generateColor(winSequences[sequenceNo][sequenceIndex++]), 0);
      addCard(generateColor(loseSequences[sequenceNo][0]), 1);
    } else {
      sequenceNo = Random().nextInt(loseSequences.length - 1);
      addCard(generateColor(loseSequences[sequenceNo][sequenceIndex++]), 0);
      addCard(generateColor(loseSequences[sequenceNo][sequenceIndex++]), 0);
      addCard(generateColor(winSequences[sequenceNo][0]), 1);
    }
  }

  void hit() {
    if (winner == -1) {
      if (future == 0)
        addCard(generateCard(), currentMove);
      else if (future == 1) {
        if (currentMove == 1)
          addCard(generateColor(loseSequences[sequenceNo][sequenceIndex++]), currentMove);
        else
          addCard(generateColor(winSequences[sequenceNo][sequenceIndex++]), currentMove);
      } else {
        if (currentMove == 0)
          addCard(generateColor(loseSequences[sequenceNo][sequenceIndex++]), currentMove);
        else
          addCard(generateColor(winSequences[sequenceNo][sequenceIndex++]), currentMove);
      }
    } else
      print("Game finnished");
  }

  void stand() {
    currentMove = 1;
    sequenceIndex = 1;
  }
}
