import 'Location.dart';
import 'Piece.dart';

class Move {
  List<StepMove> steps;
  List<AuxillaryMoveType> auxillaryEffects;
  Move(this.steps, this.auxillaryEffects);

  Location get start => steps[0].start;
  Location get end => steps[steps.length - 1].end;
}

class StepMove {
  Location start;
  Location end;

  StepMove(this.start, this.end);
}

abstract class AuxillaryMoveType {

}

class Remove extends AuxillaryMoveType {
  Location square;
  Remove(this.square);
}

class Swap extends AuxillaryMoveType {
  Location square1, square2;
  Swap(this.square1, this.square2);
}

class Replace extends AuxillaryMoveType {
  Location square;
  Piece newPiece;
  Replace(this.square, this.newPiece);
}