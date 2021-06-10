import 'Location.dart';
import 'Piece.dart';

class Position {
  List<List<Piece>> position;

  Position(this.position);

  bool isOnBoard(Location s) => s.x >= 0 && s.x < this.width && s.y >= 0 && s.y < this.height;

  int get width => position[0].length;
  int get height => position.length;

  Piece operator [](Location l) => position[l.y][l.x];

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