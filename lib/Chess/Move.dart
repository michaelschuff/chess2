import 'Location.dart';
import 'Piece.dart';

class Move {
  Piece piece;
  Location start, end;

  Move(this.piece, this.start, this.end);

  Location get diff => start - end;
}