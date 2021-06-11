import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/rendering.dart' show debugPaintPointersEnabled;

import 'Chess/Location.dart';
import 'Chess/Piece.dart';
import 'Chess/Position.dart';
import 'Chess/Rules.dart';
import 'Chess/Move.dart';

void main() {
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}
// I literally dont even care
// yeet
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChessBoard(position: Position.defaultPosition, size: 400, top: 50, left: 50),
    );
  }
}

// ignore: must_be_immutable
class ChessBoard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  ChessBoard({Key? key, required this.position, required this.size, required this.top, required this.left}) : super(key: key);

  // ignore: non_constant_identifier_names
  Position position;
  int size;
  double top, left;

  ChessGame createState() => ChessGame();
}

class ChessGame extends State<ChessBoard> {
  int pickedUpX = -1,pickedUpY = -1;
  Offset mouse = Offset(0, 0);

  void onDragStart(DragStartDetails details) {
    pickedUpX = (8 * details.localPosition.dx ~/ widget.size);
    pickedUpY = (8 * details.localPosition.dy ~/ widget.size);
    mouse = details.localPosition;
    setState(() {});
  }

  void onDragUpdate(DragUpdateDetails details) {
    mouse = details.localPosition;
    setState(() {});
  }

  void onDragEnd(DragEndDetails details) {
    Piece temp = widget.position.position[pickedUpY][pickedUpX];
    int endX = 8*mouse.dx~/widget.size;
    int endY = 8*mouse.dy~/widget.size;
    Move move = Move(temp, Location(pickedUpX, pickedUpY), Location(endX, endY));
    if (endX < 8 && endX >= 0) {
      if (endY < 8 && endY >= 0) {
        bool legal = false;
        switch (temp.name) {
          case "b": {
            legal = IsLegalBishopMove().check(widget.position, move);
          }
          break;
          case "r": {
            legal = IsLegalRookMove().check(widget.position, move);
          }
          break;
          case "n": {
            legal = IsLegalKnightMove().check(widget.position, move);
          }
          break;
          case "k": {
            legal = IsLegalKingMove().check(widget.position, move);
          }
          break;
          case "p": {
            legal = IsLegalPawnMove().check(widget.position, move);
          }
          break;
          case "q": {
            legal = IsLegalQueenMove().check(widget.position, move);
          }
          break;
        }
        if (legal) {
          widget.position.position[pickedUpY][pickedUpX] = widget.position.position[endY][endX];
          widget.position.position[endY][endX] = temp;
        }
      }
    }

    pickedUpX = -1;
    pickedUpY = -1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double squareSize = widget.size / 8.0;
    return MouseRegion(
      child: GestureDetector(
        onHorizontalDragStart: onDragStart,
        onVerticalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onVerticalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
        onVerticalDragEnd: onDragEnd,
        child: Container(
            width: widget.size as double,
            height: widget.size as double,
            child: Stack(children: [
              Image.asset("assets/images/board.png",
                fit: BoxFit.fill,
                isAntiAlias: false,
                filterQuality: FilterQuality.none,
                width: widget.size as double,
                height: widget.size as double,
              ),
              for (int y = 0; y < 8; y++)
                for (int x = 0; x < 8; x++)
                  if (pickedUpX != x || pickedUpY != y)
                    Positioned(
                        top: y * squareSize,
                        left: x * squareSize,
                        width: squareSize,
                        height: squareSize,
                        child: SvgPicture.asset(widget.position.position[y][x].imagePath!, fit: BoxFit.fitWidth)
                    ),
              if (pickedUpX != -1 && pickedUpY != -1)
                AnimatedContainer(
                  height: 8 * squareSize,
                  width: 8 * squareSize,
                  duration: Duration(milliseconds: 0),
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                          duration: const Duration(milliseconds: 0),
                          left: mouse.dx - squareSize / 2,
                          top: mouse.dy - squareSize / 2,
                          child: Container(
                            width: squareSize,
                            height: squareSize,
                            child: SvgPicture.asset(widget.position.position[pickedUpY][pickedUpX].imagePath!, fit: BoxFit.fitWidth)
                          )
                      ),
                    ],
                  ),
                )
            ])
        ),
      ),
    );
  }
}

class FENString {
  String position       = "";
  String turn           = "";
  String castling       = "";
  String lastMove       = "";
  String numHalfmoves   = "";
  String numMoves       = "";


  // ignore: non_constant_identifier_names
  FENString({String str = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"}) {
    this.string = str;
  }

  // ignore: non_constant_identifier_names
  String get boardString {
    return position.replaceAllMapped(RegExp("[a-z]"), (m) => "b${m[0]}")
        .replaceAllMapped(RegExp("[A-Z]"), (m) => "w${m[0]}")
        .replaceAllMapped(RegExp("[0-8]"), (m) => "  " * int.parse(m[0]!))
        .replaceAll("/","");
  }

  String get string => "$position $turn $castling $lastMove $numHalfmoves $numMoves";

  // ignore: non_constant_identifier_names
  set string(String FEN) {
    var arr = FEN.split(" ");
    if (arr.length != 6) return;

    position = arr[0];
    turn = arr[1];
    castling = arr[2];
    lastMove = arr[3];
    numHalfmoves = arr[4];
    numMoves = arr[5];
  }
}

