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
  Widget? resultMessage = null;
  bool showFullDealerHand = false;
  String oddsMessage = '';
  bool _gameStarted = false; // Add state variable to track if game has started

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
    // Ensure we only process valid card strings
    final validHand = hand.where((c) => c != '?').toList();
    for (var card in validHand) {
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
    _gameStarted = true; // Set game started flag

    if (calculateHandValue(playerCards) == 21) {
      revealDealerHand();
      resultMessage = Text(
        'Player hits Blackjack!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.center,
      );
       _gameStarted = false; // Game ends on Blackjack
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
    if (!_gameStarted) return; // Don't allow hit if game hasn't started

    final randomCard = cardOptions[rng.nextInt(cardOptions.length)];
    // No need to filter here, just add the card
    // final filteredPlayerCards = playerCards.whereType<String>().toList()..add(randomCard);
    playerCards.add(randomCard);
    final total = calculateHandValue(playerCards); // Calculate after adding

    String newMessage = '';
    if (total > 21) {
      revealDealerHand();
      final dealerTotal = calculateHandValue(dealerHand);
      newMessage = 'Player busts! Total: $total\n'
          'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)';
      _gameStarted = false; // Game ends on bust
    }

    setState(() {
      // playerCards.add(randomCard); // Moved adding card up
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
  if (!_gameStarted) return; // Don't allow stand if game hasn't started

  // No need to filter here
  // final filteredPlayerCards = playerCards.whereType<String>().toList();
  final playerTotal = calculateHandValue(playerCards);
  revealDealerHand(); // Reveal first

  // Dealer hits until 17 or higher
  while (calculateHandValue(dealerHand) < 17) {
    dealerHand.add(cardOptions[rng.nextInt(cardOptions.length)]);
  }
  final dealerTotal = calculateHandValue(dealerHand); // Calculate final dealer total

  String result;
  if (playerTotal > 21) result = "Player busts!"; // Should ideally not happen if stand logic is correct
  else if (dealerTotal > 21) result = "Dealer busts! You win!";
  else if (playerTotal > dealerTotal) result = "You win!";
  else if (playerTotal < dealerTotal) result = "Dealer wins!";
  else result = "Push (tie)";

  setState(() {
    resultMessage = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Player Hand: ${playerCards.join(" + ")} (Total: $playerTotal)\n'
                'Dealer Hand: ${dealerHand.join(" + ")} (Total: $dealerTotal)\n\n',
          ),
          TextSpan(
            text: result,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
    _gameStarted = false; // Game ends after stand
  });
}
  void resetGame() {
    setState(() {
      dealerHand.clear();
      playerCards.clear();
      resultMessage = null;
      oddsMessage = '';
      showFullDealerHand = false;
      _gameStarted = false; // Reset game started flag
    });
  }

  void calculateOdds() {
    if (!_gameStarted) return; // Don't calculate if game hasn't started

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

    // --- Start Basic Strategy Logic ---
    final dealerUpCardValue = cardValue(dealerUpCard);
    String recommendation;

    // Basic Strategy Rules (Simplified - doesn't handle soft hands or pairs optimally yet)
    if (playerTotal <= 11) {
      recommendation = "Recommendation: Hit"; // Always hit 11 or less
    } else if (playerTotal == 12) {
      recommendation = (dealerUpCardValue >= 4 && dealerUpCardValue <= 6)
          ? "Recommendation: Stand" // Stand vs 4-6
          : "Recommendation: Hit";   // Hit vs others
    } else if (playerTotal >= 13 && playerTotal <= 16) {
      recommendation = (dealerUpCardValue >= 2 && dealerUpCardValue <= 6)
          ? "Recommendation: Stand" // Stand vs 2-6
          : "Recommendation: Hit";   // Hit vs others
    } else { // Player total is 17 or more
      recommendation = "Recommendation: Stand"; // Always stand on 17+
    }
    // --- End Basic Strategy Logic ---


    setState(() {
      // Display the recommendation based on strategy, not flawed odds
      oddsMessage = "Player Total: $playerTotal\n"
                    "Dealer Upcard: $dealerUpCard ($dealerUpCardValue)\n\n"
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
    // Ensure suit selection is consistent for a given card instance if needed,
    // but random is fine for visual variety here.
    final suit = suits[rng.nextInt(suits.length)];
    final fileName = '${rank}_of_${suit}.png';
    // Use errorBuilder for robustness if image assets might be missing
    return Image.asset(
      'assets/cards/$fileName',
      width: 50,
      height: 70,
      errorBuilder: (context, error, stackTrace) {
        // Fallback widget if image fails to load
        return Container(
          width: 50,
          height: 70,
          color: Colors.grey,
          child: Center(child: Text(card, style: TextStyle(color: Colors.white))),
        );
      },
    );
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
              buildHandDisplay("Player", playerCards), // Player hand always fully visible
              SizedBox(height: 16),

              // Odds Section
              ElevatedButton(
                onPressed: _gameStarted ? calculateOdds : null, // Disable if game not started
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: Colors.grey[300], // Visual feedback for disabled
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
                onPressed: _gameStarted ? simulateHit : null, // Disable if game not started
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: Colors.grey[300], // Visual feedback for disabled
                ),
                child: Text('Hit'), // Simplified text
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _gameStarted ? stand : null, // Disable if game not started
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: Colors.grey[300], // Visual feedback for disabled
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
      visibleCards = [hand[0], '?']; // Show only first card and back
    }

    // Calculate total only if the hand is not empty and either the full hand is shown
    // or it's the player's hand (which is always fully visible to the player).
    int? handTotal;
    // Calculate total based on *actual* hand, not just visible cards if dealer's card is hidden
    if (hand.isNotEmpty && (!hideSecondCard || label == "Player")) {
       handTotal = calculateHandValue(hand);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // Slightly larger label
        SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4, // Add vertical spacing if cards wrap
          // Use visibleCards for display
          children: visibleCards.map((card) => buildCardImage(card)).toList(),
        ),
        // Show total if calculated
        if (handTotal != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Total: $handTotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        SizedBox(height: 12),
      ],
    );
  }
}