import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projekt3/puzzle_piece.dart';
import 'package:projekt3/puzzle_piece_creator.dart';

class PuzzleHomePage extends StatefulWidget {
  @override
  _PuzzleHomePageState createState() => _PuzzleHomePageState();
}

class _PuzzleHomePageState extends State<PuzzleHomePage>
    with SingleTickerProviderStateMixin {
  ui.Image canvasImage;
  bool _loaded = false;
  List<PuzzlePiece> pieceOnBoard = [];
  List<PuzzlePiece> pieceOnPool = [];
  DateTime startOfGameDateTime = DateTime.now();

  PuzzlePiece _currentPiece;
  Animation<Offset> _offsetAnimation;

  final GlobalKey _boardWidgetKey = GlobalKey();

  AnimationController _animController;

  @override
  void initState() {
    _animController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Puzzle'),
          ),
          body: _loaded
              ? Column(
                  children: [
                    Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: _buildBoard(),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(32),
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: pieceOnPool.length,
                        itemBuilder: (context, index) {
                          final piece = pieceOnPool[index];
                          return Center(
                            child: Draggable(
                              child: piece,
                              feedback: piece,
                              childWhenDragging: Opacity(
                                opacity: 0.24,
                                child: piece,
                              ),
                              onDragEnd: (details) {
                                _onPiecePlaced(piece, details.offset);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 32),
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
               floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(context: context,
               builder: (BuildContext context) {
                 return SafeArea(
                   child: new Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       new ListTile(
                         leading: new Icon(Icons.camera),
                         title: new Text('Camera'),
                         onTap: () {
                          _prepareGame(ImageSource.camera);
                          Navigator.pop(context);
                         },
                       ),
                       new ListTile(
                         leading: new Icon(Icons.image),
                         title: new Text('Gallery'),
                         onTap: () {
                          _prepareGame(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                       ),
                     ],
                   ),
                 );
               }
              );
            },
          tooltip: 'New Image',
          child: Icon(Icons.add),
          ),
        ),
        if (_currentPiece != null)
          AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final offset = _offsetAnimation.value;
              return Positioned(
                left: offset.dx,
                top: offset.dy,
                child: child,
              );
            },
            child: _currentPiece,
          )
      ],
    );
  }

  void _prepareGame(ImageSource source) async {
    startOfGameDateTime = DateTime.now();
    pieceOnPool.clear();
    pieceOnBoard.clear();    

    setState(() {
      _loaded = false;
    });
    canvasImage = await getImage(source);
    pieceOnPool = PuzzlePieceCreator().createPuzzlePiece(canvasImage);
    pieceOnPool.shuffle();

    setState(() {
      _loaded = true;
      print('Loading done');
    });
  }

  Future<ui.Image> getImage(ImageSource source) async {
    final imageSize = 300.0;
    var image = await ImagePicker.pickImage(source: source, maxWidth: imageSize * 1.7 , maxHeight: imageSize * 1.7);
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(await image.readAsBytes(), (ui.Image img) {
      setState(() {
        _loaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildBoard() {
    return Container(
      key: _boardWidgetKey,
      width: 300,
      height: 300,
      color: Colors.blue.shade100,
      child: Stack(
        children: [
          for (var piece in pieceOnBoard)
            Positioned(
              left: piece.boundary.left,
              top: piece.boundary.top,
              child: piece,
            ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(String time) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('You did it!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('The time you needed equals ' + time + ' seconds'),
            ],
          ),
        ),
      );
    },
  );
}

  void _onPiecePlaced(PuzzlePiece piece, Offset pieceDropPosition) {
    final RenderBox box = _boardWidgetKey.currentContext.findRenderObject();
    final boardPosition = box.localToGlobal(Offset.zero);
    final targetPosition =
        boardPosition.translate(piece.boundary.left, piece.boundary.top);

    var counter = 0;
    const threshold = 48.0;

    final distance = (pieceDropPosition - targetPosition).distance;
    if (distance < threshold) {
      setState(() {
        _currentPiece = piece;
        pieceOnPool.remove(piece);
        if (pieceOnPool.length == 0) {
          _showMyDialog(DateTime.now().difference(startOfGameDateTime).inSeconds.toString());
        }
      });
      _offsetAnimation = Tween<Offset>(
        begin: pieceDropPosition,
        end: targetPosition,
      ).animate(_animController);

      _animController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (counter == 0) {
            pieceOnBoard.add(piece);
            counter++;
          }
          setState(() {

            _currentPiece = null;
          });
        }
      });
      const spring = SpringDescription(
        mass: 30,
        stiffness: 1,
        damping: 1,
      );

      final simulation = SpringSimulation(spring, 0, 1, -distance);

      _animController.animateWith(simulation);
    }
  }
}