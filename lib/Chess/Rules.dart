import 'Location.dart';
import 'Move.dart';
import 'Position.dart';

abstract class Rule {
  bool doesNotViolate(Position p, Move m);
  bool doesViolate(Position p, Move m);
}

class PieceMovementRule extends Rule {
  String pieceID;
  List<Dir> legalSteps;
  int sequentialStepLimit;

  PieceMovementRule(this.pieceID, this.legalSteps, this.sequentialStepLimit);

  @override
  bool doesNotViolate(Position p, Move m) {
    String color = p[m.start].name ?? "";
    if (color == "") return false;
    return true;
  }

  @override
  bool doesViolate(Position position, Move move) {
    return !doesNotViolate(position, move);
  }
}

class Rules {
  List<Rule> rules;
  Rules(this.rules);

  bool doesNotViolate(Position position, Move move) {
    for (int i = 0; i < rules.length; i++) {
      if (!rules[i].doesNotViolate(position, move)) {
        return false;
      }
    }
    return true;
  }

  bool doesViolate(Position position, Move move) {
    return !doesNotViolate(position, move);
  }
}