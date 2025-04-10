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
  List<String> dealerHand = [];
  List<String> playerCards = [];
  Widget? resultMessage = null; // Declare resultMessage here
  bool showFullDealerHand = false;
  String oddsMessage = '';

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

 void dealInitialCards() {
  setState(() {
    dealerHand = [
      cardOptions[rng.nextInt(cardOptions.length)], // Face-up card
      '?' // Face-down card
    ];

    playerCards = [
      cardOptions[rng.nextInt(cardOptions.length)],
      cardOptions[rng.nextInt(cardOptions.length)]
    ];

    resultMessage = null;
    oddsMessage = '';
    showFullDealerHand = false;

    if (calculateHandValue(playerCards) == 21) {
      revealDealerHand();
      resultMessage = Text(
        'Player hits Blackjack!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.center,
      );
    }
  });
}

  void revealDealerHand() {
    setState(() {
      // Replace the face-down card with a random card
      if (dealerHand.contains('?')) {
        dealerHand[1] = cardOptions[rng.nextInt(cardOptions.length)];
      }
      showFullDealerHand = true;
    });
  }

  void simulateHit() {
    final randomCard = cardOptions[rng.nextInt(cardOptions.length)];
    final filteredPlayerCards = playerCards.whereType<String>().toList()..add(randomCard);
    final total = calculateHandValue(filteredPlayerCards);

    String newMessage = '';
    if (total > 21) {
      revealDealerHand();
      final dealerTotal = calculateHandValue(dealerHand);
      newMessage = 'Player busts! Total: $total\n'
          'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)';
    }

    setState(() {
      playerCards.add(randomCard);
      if (newMessage.isNotEmpty) {
        resultMessage = Text(
  newMessage,
  style: TextStyle(fontSize: 16),
  textAlign: TextAlign.center,
);
      }
    });
  }

 void stand() {
  final filteredPlayerCards = playerCards.whereType<String>().toList();
  final playerTotal = calculateHandValue(filteredPlayerCards);
  revealDealerHand();
  final dealerTotal = calculateHandValue(dealerHand);

  String result;
  if (playerTotal > 21) result = "Player busts!";
  else if (dealerTotal > 21) result = "Dealer busts!";
  else if (playerTotal > dealerTotal) result = "You win!";
  else if (playerTotal < dealerTotal) result = "Dealer wins!";
  else result = "Push (tie)";

  setState(() {
    resultMessage = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Player Hand: ${filteredPlayerCards.join(" + ")} (Total: $playerTotal)\n'
                'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)\n\n',
          ),
          TextSpan(
            text: result,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  });
}
  void resetGame() {
    setState(() {
      dealerHand.clear();
      playerCards.clear();
      resultMessage = null;
      oddsMessage = '';
      showFullDealerHand = false;
    });
  }

  void calculateOdds() {
  final playerTotal = calculateHandValue(playerCards);
  final dealerUpCard = dealerHand.isNotEmpty ? dealerHand[0] : null;

  if (playerTotal > 21) {
    setState(() {
      oddsMessage = "Player has already busted!";
    });
    return;
  }

  if (dealerUpCard == null || dealerUpCard == '?') {
    setState(() {
      oddsMessage = "Dealer's upcard is not visible.";
    });
    return;
  }

  // Simplified odds calculation logic
  double winOdds = (21 - playerTotal) / 21 * 100;
  double loseOdds = (playerTotal / 21) * 100;

  // Add recommendation logic
  String recommendation;
  if (winOdds > 50) {
    recommendation = "Recommendation: Hit";
  } else if (loseOdds > 50) {
    recommendation = "Recommendation: Stand";
  } else {
    recommendation = "Recommendation: Caution";
  }

  setState(() {
    oddsMessage = "Win Odds: ${winOdds.toStringAsFixed(2)}%\n"
        "Lose Odds: ${loseOdds.toStringAsFixed(2)}%\n"
        "$recommendation";
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
              // Dealer Section
              Text(
                'Dealer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              buildHandDisplay("Dealer", dealerHand, hideSecondCard: !showFullDealerHand),
              SizedBox(height: 16),

              // Player Section
              Text(
                'Player',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              buildHandDisplay("Player", playerCards),
              SizedBox(height: 16),

              // Odds Section
              ElevatedButton(
                onPressed: calculateOdds,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Calculate Odds'),
              ),
              if (oddsMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    oddsMessage,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 16),
              // Result Message
              if (resultMessage != null)
                Card(
                  color: Colors.yellow[100],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: resultMessage,
                ),
        ),
              SizedBox(height: 16),

              // Buttons
              ElevatedButton(
                onPressed: dealInitialCards,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: Text('Start / Deal'),
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
}