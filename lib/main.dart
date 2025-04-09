import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BlackjackOddsApp());
}

class BlackjackOddsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackjack Odds Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: BlackjackHomePage(),
    );
  }
}

class BlackjackHomePage extends StatefulWidget {
  @override
  _BlackjackHomePageState createState() => _BlackjackHomePageState();
}

class _BlackjackHomePageState extends State<BlackjackHomePage> {
  String? dealerCard;
  List<String?> playerCards = [null, null];
  List<String> dealerHand = [];
  String resultMessage = '';
  bool showFullDealerHand = false;

  final List<String> cardOptions = [
    'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'
  ];

  final List<String> suits = ['clubs', 'diamonds', 'hearts', 'spades'];

  final Random rng = Random();

  int cardValue(String card) {
    if (card == 'A') return 11;
    if (['J', 'Q', 'K'].contains(card)) return 10;
    return int.parse(card);
  }

  int calculateHandValue(List<String> hand) {
    int total = 0;
    int aceCount = 0;
    for (var card in hand) {
      int value = cardValue(card);
      total += value;
      if (card == 'A') aceCount++;
    }
    while (total > 21 && aceCount > 0) {
      total -= 10;
      aceCount--;
    }
    return total;
  }

  void simulateDealerDraw() {
    dealerHand = [dealerCard!];
    while (calculateHandValue(dealerHand) < 17) {
      final nextCard = cardOptions[rng.nextInt(cardOptions.length)];
      dealerHand.add(nextCard);
    }
  }

  double calculateBustProbability(List<String> hand) {
    final int total = calculateHandValue(hand);
    if (total >= 21) return 100.0;

    int bustCount = 0;
    int totalCards = 13;

    for (var card in cardOptions) {
      List<String> tempHand = List.from(hand)..add(card);
      if (calculateHandValue(tempHand) > 21) bustCount++;
    }

    return (bustCount / totalCards) * 100;
  }

  String getBasicStrategy(String dealer, List<String> hand) {
    int total = calculateHandValue(hand);
    if (total <= 11) return 'Hit';
    if (total >= 17) return 'Stand';
    int dealerVal = cardValue(dealer);
    if (total >= 12 && total <= 16) {
      if (dealerVal >= 7) return 'Hit';
      else return 'Stand';
    }
    return 'Undetermined';
  }

  void calculateOdds() {
    if (dealerCard != null && playerCards.every((c) => c != null)) {
      final filteredPlayerCards = playerCards.whereType<String>().toList();
      final bustProb = calculateBustProbability(filteredPlayerCards);
      final suggestion = getBasicStrategy(dealerCard!, filteredPlayerCards);

      setState(() {
        showFullDealerHand = false;
        dealerHand = [dealerCard!];
        resultMessage =
            'Dealer Upcard: $dealerCard\n'
            'Player: ${filteredPlayerCards.join(" + ")} (Total: ${calculateHandValue(filteredPlayerCards)})\n\n'
            'Bust Probability if Hit: ${bustProb.toStringAsFixed(1)}%\n'
            'Suggested Move: $suggestion';
      });
    }
  }

  void simulateHit() {
    final availableCards = List<String>.from(cardOptions);
    final randomCard = availableCards[rng.nextInt(availableCards.length)];
    final filteredPlayerCards = playerCards.whereType<String>().toList()..add(randomCard);
    final total = calculateHandValue(filteredPlayerCards);

    String newMessage = '';
    if (total > 21) {
      simulateDealerDraw();
      showFullDealerHand = true;
      final dealerTotal = calculateHandValue(dealerHand);
      newMessage = 'Player busts! Total: $total\n'
    'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)';
    }

    setState(() {
      playerCards.add(randomCard);
      if (newMessage.isNotEmpty) {
        resultMessage = newMessage;
      }
    });
  }

  void stand() {
    final filteredPlayerCards = playerCards.whereType<String>().toList();
    final playerTotal = calculateHandValue(filteredPlayerCards);
    simulateDealerDraw();
    final dealerTotal = calculateHandValue(dealerHand);

    String result;
    if (playerTotal > 21) result = "Player busts!";
    else if (dealerTotal > 21) result = "Dealer busts!";
    else if (playerTotal > dealerTotal) result = "You win!";
    else if (playerTotal < dealerTotal) result = "Dealer wins!";
    else result = "Push (tie)";

    setState(() {
      showFullDealerHand = true;
      resultMessage =
          'Player Hand: ${filteredPlayerCards.join(" + ")} (Total: $playerTotal)\n'
          'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)\n\n$result';
    });
  }

  void resetGame() {
    setState(() {
      dealerCard = null;
      playerCards = [null, null];
      dealerHand.clear();
      resultMessage = '';
      showFullDealerHand = false;
    });
  }

  Widget buildCardImage(String card) {
    if (card == '?') {
      return Image.asset('assets/cards/back.png', width: 50, height: 70);
    }
    final rankMap = {
      'A': 'ace',
      'J': 'jack',
      'Q': 'queen',
      'K': 'king',
      '10': '10',
      '2': '2',
      '3': '3',
      '4': '4',
      '5': '5',
      '6': '6',
      '7': '7',
      '8': '8',
      '9': '9'
    };
    final rank = rankMap[card] ?? card.toLowerCase();
    final suit = suits[rng.nextInt(suits.length)];
    final fileName = '${rank}_of_${suit}.png';
    return Image.asset('assets/cards/$fileName', width: 50, height: 70);
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlayerCards = playerCards.whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Blackjack Odds Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDropdown("Dealer's Upcard", dealerCard, (val) => setState(() => dealerCard = val)),
              buildDropdown('Player Card 1', playerCards[0], (val) => setState(() => playerCards[0] = val)),
              buildDropdown('Player Card 2', playerCards[1], (val) => setState(() => playerCards[1] = val)),
              SizedBox(height: 16),
              if (filteredPlayerCards.length >= 2)
                buildHandDisplay("Player Hand", filteredPlayerCards),
              if (dealerHand.isNotEmpty)
                buildHandDisplay("Dealer Hand", dealerHand, hideSecondCard: !showFullDealerHand),
              SizedBox(height: 16),
              if (resultMessage.isNotEmpty)
                Card(
                  color: Colors.yellow[100],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      resultMessage,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateOdds,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Calculate Odds'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: simulateHit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Hit (Draw Random Card)'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: stand,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Stand'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: resetGame,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Reset Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHandDisplay(String label, List<String> hand, {bool hideSecondCard = false}) {
    List<String> visibleCards = List.from(hand);
    if (hideSecondCard && hand.length > 1) {
      visibleCards = [hand[0], '?'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: visibleCards.map((card) => buildCardImage(card)).toList(),
        ),
        if (!hideSecondCard || hand.length == 1)
          Column(
            children: [
              SizedBox(height: 8),
              Text('Total: ${calculateHandValue(hand)}', style: TextStyle(fontSize: 16)),
            ],
          ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget buildDropdown(String label, String? value, ValueChanged<String?> onChanged) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select a card'),
              onChanged: onChanged,
              items: cardOptions.map((card) {
                return DropdownMenuItem<String>(
                  value: card,
                  child: Text(card),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
