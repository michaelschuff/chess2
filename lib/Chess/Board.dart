import 'Move.dart';
import 'Position.dart';
import 'Rules.dart';

class Board {
  Position position;
  Rules rules;
  Board(this.position, this.rules);

  bool isLegalMove(Move move) => rules.doesNotViolate(position, move);
}
