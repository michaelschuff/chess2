import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
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
      home: ChessBoard(FENStr: FENString(), size: 400),
    );
  }
}

class ChessBoard extends StatefulWidget {
  // ignore: non_constant_identifier_names
  ChessBoard({Key? key, required this.FENStr, required this.size}) : super(key: key);

  // ignore: non_constant_identifier_names
  FENString FENStr;
  int size;

  ChessGame createState() => ChessGame();
}

class ChessGame extends State<ChessBoard> {
  @override
  Widget build(BuildContext context) {
    String board = widget.FENStr.boardString;
    double squareSize = widget.size / 8.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.FENStr.string),
      ),

      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          width: widget.size as double,
          height: widget.size as double,
          child: Image.asset("assets/images/board.png", fit: BoxFit.fitWidth, isAntiAlias: false, filterQuality: FilterQuality.none),
        ),

        for (int y = 0; y < 8; y++)
          for (int x = 0; x < 8; x++)
            Positioned(
                top: y * squareSize,
                left: x * squareSize,
                width: squareSize,
                height: squareSize,
                child: SvgPicture.asset("assets/images/${board.substring(2 * (8 * y + x), 2 * (8 * y + x) + 2).toLowerCase()}.svg", fit: BoxFit.fitWidth)
            ),
      ]),
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