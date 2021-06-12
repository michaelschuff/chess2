import 'Location.dart';
import 'Piece.dart';

class Position {
  List<List<Piece>> position;
  bool wQueenside, wKingside, bQueenside, bKingside;

  Position(this.position, {this.wQueenside = true, this.wKingside = true, this.bQueenside = true, this.bKingside = true});
  Position.clone(Position pos): this(pos.position.map((row) => row.map((item) => Piece(item.color, item.type, item.imagePath)).toList()).toList(),
                                     wQueenside: pos.wQueenside,
                                     wKingside: pos.wKingside,
                                     bQueenside: pos.bQueenside,
                                     bKingside: pos.bKingside, );

  bool isOnBoard(Location s) => s.x >= 0 && s.x < this.width && s.y >= 0 && s.y < this.height;

  int get width => position[0].length;
  int get height => position.length;

  Piece operator [](Location l) => position[l.y][l.x];
  operator []=(Location l, Piece p) {
    position[l.y][l.x] = p;
  }
  String get string {
    String s = "+-----------------------+\n|";
    for (int y = 0; y < height; y++) {
      if (y != 0 && y != height) s += "\n|--+--+--+--+--+--+--+--|\n|";
      for (int x = 0; x < width; x++) s += this.position[y][x].name + "|";
    }
    s += "\n+-----------------------+\n";
    return s;
  }

  static Position defaultPosition = Position([
    [Piece.br  , Piece.bn  , Piece.bb  , Piece.bq  , Piece.bk  , Piece.bb  , Piece.bn  , Piece.br  ],
    [Piece.bp  , Piece.bp  , Piece.bp  , Piece.bp  , Piece.bp  , Piece.bp  , Piece.bp  , Piece.bp  ],
    [Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none],
    [Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none],
    [Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none],
    [Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none, Piece.none],
    [Piece.wp  , Piece.wp  , Piece.wp  , Piece.wp  , Piece.wp  , Piece.wp  , Piece.wp  , Piece.wp  ],
    [Piece.wr  , Piece.wn  , Piece.wb  , Piece.wq  , Piece.wk  , Piece.wb  , Piece.wn  , Piece.wr  ]]);
}