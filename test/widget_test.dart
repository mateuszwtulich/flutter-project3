// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:projekt3/puzzle_piece.dart';
import 'package:projekt3/puzzle_piece_creator.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  
  test('12 puzzles should be created', () async {
    ui.Image image = await createTestImage(width: 300, height: 300);
    
    expect(PuzzlePieceCreator().createPuzzlePiece(image).length, 12);
  });

  test('12 puzzles should be created and have the same size', () async {
    ui.Image image = await createTestImage(width: 300, height: 300);
    Size expectedSize = Size(75, 100);
    PuzzlePieceCreator().createPuzzlePiece(image).forEach((element) {
      expect(element.imageSize, expectedSize);
    });
  });

  test('12 puzzles should be created and not have the expected size', () async {
    ui.Image image = await createTestImage(width: 1000, height: 100);
    Size expectedSize = Size(100, 100);
    
    expect(PuzzlePieceCreator().createPuzzlePiece(image).any((element) => element.imageSize != expectedSize), true);
  });

    test('12 puzzles should be created and have expected offset', () async {
    ui.Image image = await createTestImage(width: 300, height: 300);
    Size expectedSize = Size(75, 100);
    List<List<Offset>> expectedPoints = [[Offset(0,0), Offset(75,0), Offset(75,100), Offset(0,100)],
                                         [Offset(0,100), Offset(75,100), Offset(75,200), Offset(0,200)],
                                         [Offset(0,200), Offset(75,200), Offset(75,300), Offset(0,300)],
                                         [Offset(75,0), Offset(150,0), Offset(150,100), Offset(75,100)],
                                         [Offset(75,100), Offset(150,100), Offset(150,200), Offset(75,200)],
                                         [Offset(75,200), Offset(150,200), Offset(150,300), Offset(75,300)],
                                         [Offset(150,0), Offset(225,0), Offset(225,100), Offset(150,100)],
                                         [Offset(150,100), Offset(225,100), Offset(225,200), Offset(150,200)],
                                         [Offset(150,200), Offset(225,200), Offset(225,300), Offset(150,300)],
                                         [Offset(225,0), Offset(300,0), Offset(300,100), Offset(225,100)],
                                         [Offset(225,100), Offset(300,100), Offset(300,200), Offset(225,200)],
                                         [Offset(225,200), Offset(300,200), Offset(300,300), Offset(225,300)]];

    List<PuzzlePiece> list = PuzzlePieceCreator().createPuzzlePiece(image);
    for (var i = 0; i < 12; i++) {
      expect(list[i].points, expectedPoints[i]);
    }
  });
}
