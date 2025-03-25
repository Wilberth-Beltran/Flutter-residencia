import 'dart:async';
import 'dart:math';
import 'package:buenos_habitos/page/games/Cards/constantes/icons.dart';
import 'package:flutter/material.dart';
import 'card_item.dart';

class Game {
  Game(this.gridSize) {
    generateCards();
  }
  final int gridSize;

  List<CardItem> cards = [];
  bool isGameOver = false;
  Set<String> usedImages = {}; // Ahora usaremos imágenes en lugar de iconos

  void generateCards() {
    generateImages();
    cards = [];
    final List<Color> cardColors = Colors.primaries.toList();

    for (int i = 0; i < (gridSize * gridSize / 2); i++) {
      final cardValue = i + 1;
      final String image = usedImages.elementAt(i); // Obtener la imagen
      final Color cardColor = cardColors[i % cardColors.length];

      final List<CardItem> newCards = _createCardItems(image, cardColor, cardValue);
      cards.addAll(newCards);
    }
    cards.shuffle(Random());
  }

  void generateImages() {
    usedImages = <String>{};
    for (int j = 0; j < (gridSize * gridSize / 2); j++) {
      final String image = _getRandomCardImage();
      usedImages.add(image);
      usedImages.add(image); // Agregar dos veces para asegurar pares
    }
  }

  void resetGame() {
    generateCards();
    isGameOver = false;
  }

  void onCardPressed(int index) {
  final List<int> visibleCardIndexes = _getVisibleCardIndexes();

  //  Verifica que no haya más de 2 cartas volteadas antes de permitir otra acción
  if (visibleCardIndexes.length >= 2) {
    return; // Si ya hay 2 cartas levantadas, ignorar más clics
  }

  cards[index].state = CardState.visible;
  visibleCardIndexes.add(index);

  // Esperar a que haya exactamente 2 cartas volteadas para hacer la comparación
  if (visibleCardIndexes.length == 2) {
    final CardItem card1 = cards[visibleCardIndexes[0]];
    final CardItem card2 = cards[visibleCardIndexes[1]];

    if (card1.value == card2.value) {
      // ✅ Las cartas coinciden, se quedan descubiertas
      card1.state = CardState.guessed;
      card2.state = CardState.guessed;
      isGameOver = _isGameOver();
    } else {
      //  No coinciden, ocultarlas después de 1 segundo
      Future.delayed(const Duration(milliseconds: 1000), () {
        card1.state = CardState.hidden;
        card2.state = CardState.hidden;
      });
    }
  }
}


  List<CardItem> _createCardItems(String imagePath, Color cardColor, int cardValue) {
    return List.generate(
      2,
      (index) => CardItem(
        value: cardValue,
        imagePath: imagePath,
        color: cardColor,
      ),
    );
  }

  String _getRandomCardImage() {
    final Random random = Random();
    String image;
    do {
      image = cardImages[random.nextInt(cardImages.length)];
    } while (usedImages.contains(image)); // Evita repetir imágenes en la selección
    return image;
  }

  List<int> _getVisibleCardIndexes() {
    return cards
        .asMap()
        .entries
        .where((entry) => entry.value.state == CardState.visible)
        .map((entry) => entry.key)
        .toList();
  }

  bool _isGameOver() {
    return cards.every((card) => card.state == CardState.guessed);
  }
}
