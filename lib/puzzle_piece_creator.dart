import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:projekt3/puzzle_piece.dart';


class PuzzlePieceCreator {
  List<PuzzlePiece> createPuzzlePiece(ui.Image canvasImage){
    final imageSize = 300;
    return [
      for (int i = 0; i < 4; i++)
        for (int j = 0; j < 3; j++)
          PuzzlePiece(
            key: UniqueKey(),
            image: canvasImage,
            imageSize: Size(75 , 100 ),
            points: [
              Offset((i / 4) * imageSize , (j / 3) * imageSize ),
              Offset(((i + 1) / 4) * imageSize , (j / 3) * imageSize ),
              Offset(((i + 1) / 4) * imageSize , ((j + 1) / 3) * imageSize ),
              Offset((i / 4) * imageSize , ((j + 1) / 3) * imageSize ),
            ],
          ),
    ];
  }

}