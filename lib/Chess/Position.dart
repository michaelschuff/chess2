import 'Location.dart';
import 'Piece.dart';

class Position {
  int width = 0;
  int height = 0;
  List<List<Piece>> position;

  Position(this.position) {
    this.width = position[0].length;
    this.height = position.length;
  }

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