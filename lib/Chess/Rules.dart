import 'dart:collection';

import 'Location.dart';
import 'Move.dart';
import 'Piece.dart';
import 'Position.dart';

abstract class Rule {

}

abstract class PieceMovementRule {
  bool check(Position position, Move move);
}

class IsLegalBishopMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) => (move.start.y - move.end.y).abs() == (move.start.x - move.end.x).abs();
}

class IsLegalRookMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) => (move.start.y == move.end.y) != (move.start.x == move.end.x);
}

class IsLegalKnightMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    Location diff = move.diff.abs();
    return (diff.y == 2 && diff.x == 1) || (diff.y == 1 && diff.x == 2);
  }
}

class IsLegalKingMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    Location adiff = move.diff.abs();
    return (adiff.x < 1 && adiff.y < 1) && (adiff.x == 1 || adiff.y == 1);
  }
}

class IsLegalPawnMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    if (move.diff.y == 0) return false;
    if (move.piece.color == "w") {
      if (move.diff.y == 2 && move.start.y == 7-1 && move.diff.x == 0)
        return position.position[7 - 2][move.start.x].color != "w" && position[move.end].color != "w";
      if (move.diff.y == 1) {
        if (move.diff.x == 0) return position[move.end].color != "w";
        if ((move.diff.x == 1 || move.diff.x == -1) &&
            position.isOnBoard(move.end))
          return position[move.end].color == "b";
      }
    } else if (move.piece.color == "b") {
      if (move.diff.y == -2 && move.start.y == 7-6 && move.diff.x == 0)
          return position.position[7 - 5][move.start.x].color != "b" && position[move.end].color != "b";
      if (move.diff.y == -1) {
        if (move.diff.x == 0) return position[move.end].color != "b";
        if ((move.diff.x == 1 || move.diff.x == -1) && position.isOnBoard(move.end))
          return position[move.end].color == "w";
      }
    }
    return false;
  }
}

class IsLegalQueenMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) => IsLegalRookMove().check(position, move) ||
                                              IsLegalBishopMove().check(position, move);
}

class Rules {
  HashMap pieceMovementRules = new HashMap<Piece, PieceMovementRule>();
  List<Rules> generalRules;
  Rules(this.pieceMovementRules, this.generalRules);

  bool isLegalMove(Position position, Move move) {
    return pieceMovementRules[move.piece].check(position, move);
  }
}