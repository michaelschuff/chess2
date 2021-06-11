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

