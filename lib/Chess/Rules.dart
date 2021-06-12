import 'dart:collection';

import 'Location.dart';
import 'Move.dart';
import 'Piece.dart';
import 'Position.dart';

class BasicRules {
  // ignore: non_constant_identifier_names
  static bool IsKingInCheck(Position pos, String color) {
    Location delta = Location(0, 0);
    Location kPos = Location(-1, -1);
    String oppo;
    List<Location> horz = [
      Location(0,1), Location(1,0),
      Location(0,-1), Location(-1,0)];
    List<Location> diag = [
      Location(1,1), Location(1,-1),
      Location(-1,-1), Location(-1,1)];
    List<Location> knight = [
      Location(1,2), Location(2,1),
      Location(2,-1), Location(1,-2),
      Location(-1,-2), Location(-2,-1),
      Location(-2,1), Location(-1,2)];
    if (color == "w") oppo = "b";
    else if (color == "b") oppo = "w";
    else return false;

    for (int y = 0; y < pos.height; y++)
      for (int x = 0; x < pos.width; x++)
        if (pos.position[y][x].name == color + "k")
            kPos = Location(x, y);

    if (color == 'w') {
      if (pos.isOnBoard(kPos + Location(1, -1)))
        if (pos[kPos + Location(1, -1)].name == "bp") return true;
      if (pos.isOnBoard(kPos + Location(-1, -1)))
        if (pos[kPos + Location(-1, -1)].name == "bp") return true;
    } else {
      if (pos.isOnBoard(kPos + Location(1, 1)))
        if (pos[kPos + Location(1, 1)].name == "wp") return true;
      if (pos.isOnBoard(kPos + Location(-1, 1)))
        if (pos[kPos + Location(-1, 1)].name == "wp") return true;
    }

    for (var h = 0; h < 4; h++) {
      while (pos.isOnBoard(kPos + delta + horz[h])) {
        delta += horz[h];
        if (pos[kPos + delta].name == oppo + "r" || pos[kPos + delta].name == oppo + "q") return true;
        if (pos[kPos + delta].color != " ") break;
      }
      delta = Location(0,0);
    }

    for (var di = 0; di < 4; di++) {
      while (pos.isOnBoard(kPos + delta + diag[di])) {
        delta += diag[di];
        if (pos[kPos + delta].name == oppo + "b" || pos[kPos + delta].name == oppo + "q") return true;
        if (pos[kPos + delta].color != " ") break;
      }
      delta = Location(0,0);
    }

    for (var kn = 0; kn < 8; kn++)
      if (pos.isOnBoard(kPos + knight[kn]))
        if (pos[kPos + knight[kn]].name == oppo + 'n') return true;

    for (int allD = 0; allD < 4; allD++) {
      if (pos.isOnBoard(kPos + horz[allD]))
        if (pos[kPos + horz[allD]].name == oppo + "k") return true;
      if (pos.isOnBoard(kPos + diag[allD]))
        if (pos[kPos + diag[allD]].name == oppo + "k") return true;
    }

    return false;
  }

  // ignore: non_constant_identifier_names
  static Position MovePiece(Position pos, Move move) {
    var color = move.piece.color;
    var b = Position.clone(pos);
    if (move.piece.type == 'k') {
      if (color == 'w') {
        b.wQueenside = false;
        b.wKingside = false;
      } else {
        b.bQueenside = false;
        b.bKingside = false;
      }
    }
    if (move.piece.type == 'r') {
      Location kPos = Location(-1, -1);
      for (int y = 0; y < pos.height; y++)
        for (int x = 0; x < pos.width; x++)
          if (pos.position[y][x].name == color + "k")
            kPos = Location(x, y);
      if (move.start.x > kPos.x) {
        if (color == 'w') b.wKingside = false;
        else b.bKingside = false;
      } else {
        if (color == 'w') b.wQueenside = false;
        else b.bQueenside = false;
      }
    }
    if (move.piece.type == 'k' && move.start.x == 4) {
      if (move.end.x == 6) {
        b.position[move.end.y][5] = color == 'w' ? Piece.wr : Piece.br;
        b.position[move.end.y][7] = Piece.none;
        if (color == 'w') {
          b.wQueenside = false;
          b.wKingside = false;
        } else {
          b.bQueenside = false;
          b.bKingside = false;
        }
      } else if (move.end.x == 2) {
        b.position[move.end.y][3] = color == 'w' ? Piece.wr : Piece.br;
        b.position[move.end.y][0] = Piece.none;
        if (color == 'w') {
          b.wQueenside = false;
          b.wKingside = false;
        } else {
          b.bQueenside = false;
          b.bKingside = false;
        }
      }
    } else if (move.piece.type == "p" && b[move.end] == Piece.none && move.diff.x != 0) {
      if (move.piece.color == "w" && b.position[move.end.y + 1][move.end.x] == Piece.bp)
        b.position[move.end.y + 1][move.end.x] = Piece.none;
      else if (move.piece.color == "b" && b.position[move.end.y - 1][move.end.x] == Piece.wp)
        b.position[move.end.y - 1][move.end.x] = Piece.none;
    }

    b[move.end] = b[move.start];
    b[move.start] = Piece.none;
    // if (promoPiece != '') {
    //   b[move.end] = color + promoPiece;
    // }
    return b;
  }
}

abstract class PieceMovementRule {
  bool check(Position position, Move move);
}

class IsLegalBishopMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) =>
      move.diff.y.abs() == move.diff.x.abs() &&
      !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, move), move.piece.color);
}

class IsLegalRookMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) =>
      (move.diff.y == 0) != (move.diff.x == 0) &&
      !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, move), move.piece.color);
}

class IsLegalKnightMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    Location diff = move.diff.abs();
    return (diff.y == 2 && diff.x == 1) || (diff.y == 1 && diff.x == 2) &&
        !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, move), move.piece.color);
  }
}

class IsLegalKingMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    if (BasicRules.IsKingInCheck(position, move.piece.color) ||
        BasicRules.IsKingInCheck(BasicRules.MovePiece(position, move), move.piece.color)) return false;
    Location adiff = move.diff.abs();
    if ((adiff.x < 1 && adiff.y < 1) && (adiff.x == 1 || adiff.y == 1)) return true;
    if (adiff.y == 0) {
      if (move.piece.color == "w") {
        if (move.diff.x == 2 && position.wKingside &&
            position.position[move.start.y][move.start.x + 1].color == " " &&
            !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, Move(Piece.wk,move.start, move.start + Location(0, 1))), move.piece.color) &&
            position.position[7 - move.end.y][move.end.x].color == " ") return true;
        if (move.diff.x == -2 && position.wQueenside &&
            position.position[move.start.y][move.start.x - 1].color == " " &&
            !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, Move(Piece.wk,move.start, move.start + Location(0, -1))), move.piece.color) &&
            position.position[move.start.y][move.start.x - 3].color == " " &&
            position.position[7 - move.end.y][move.end.x].color == " ") return true;
      } else {
        if (move.diff.x == 2 && position.bKingside &&
            position.position[move.start.y][move.start.x + 1].color == " " &&
            !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, Move(Piece.bk,move.start, move.start + Location(0, 1))), move.piece.color) &&
            position.position[7 - move.end.y][move.end.x].color == " ") return true;
        if (move.diff.x == -2 && position.bQueenside &&
            position.position[move.start.y][move.start.x - 1].color == " " &&
            !BasicRules.IsKingInCheck(BasicRules.MovePiece(position, Move(Piece.bk,move.start, move.start + Location(0, -1))), move.piece.color) &&
            position.position[move.start.y][move.start.x - 3].color == " " &&
            position.position[7 - move.end.y][move.end.x].color == " ") return true;
      }
    }
    return false;
  }
}

class IsLegalPawnMove implements PieceMovementRule {
  @override
  bool check(Position position, Move move) {
    if (move.diff.y == 0 || BasicRules.IsKingInCheck(
        BasicRules.MovePiece(position, move), move.piece.color)) return false;
    if (move.piece.color == "w") {
      if (move.diff.y == 2 && move.start.y == 7-1 && move.diff.x == 0) {
        return position.position[7 - 2][move.start.x].color != "w" && position.position[7 - move.end.y][move.end.x].color != "w";
      }
      if (move.diff.y == 1) {
        if (move.diff.x == 0) return position.position[7 - move.end.y][move.end.x].color != "w";
        if ((move.diff.x == 1 || move.diff.x == -1) &&
            position.isOnBoard(move.end))
          return position.position[7 - move.end.y][move.end.x].color == "b";
      }
    } else if (move.piece.color == "b") {
      if (move.diff.y == -2 && move.start.y == 7-6 && move.diff.x == 0)
          return position.position[7 - 5][move.start.x].color != "b" && position.position[7 - move.end.y][move.end.x].color != "b";
      if (move.diff.y == -1) {
        if (move.diff.x == 0) return position.position[7 - move.end.y][move.end.x].color != "b";
        if ((move.diff.x == 1 || move.diff.x == -1) && position.isOnBoard(move.end))
          return position.position[7 - move.end.y][move.end.x].color == "w";
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

  bool isLegalMove(Position position, Move move) => pieceMovementRules[move.piece].check(position, move);
}