import 'package:flutter/material.dart';
import 'package:solitaire_game/screen/solitaire_games_screen.dart';

void main() {
  runApp(const SolitaireGame());
}

class SolitaireGame extends StatelessWidget {
  const SolitaireGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solitaire Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SolitaireGamesScreen(),
    );
  }
}
