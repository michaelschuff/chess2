class Location {
  int x;
  int y;

  Location(this.x, this.y);
  Location operator +(Location other) => Location(this.x + other.x, this.y + other.y);
  Location operator -(Location other) => Location(this.x - other.x, this.y - other.y);
  Location operator *(int other) => Location(this.x * other, this.y * other);
  // Location operator /(int other) => Location(this.x ~/ other, this.y ~/ other);
  Location operator -() => Location(-this.x, -this.y);


  Location abs() => Location(this.x.abs(), this.y.abs());
}

class Dir extends Location {
  Dir(int px, int py) : super(px, py);

  int get x => x;
  int get y => y;

  static final U = Dir( 0,  1);
  static final D = Dir( 0, -1);
  static final L = Dir(-1,  0);
  static final R = Dir( 1,  0);


  static final UL = Dir(-1,  1); // ignore: non_constant_identifier_names
  static final UR = Dir( 1,  1); // ignore: non_constant_identifier_names
  static final DL = Dir(-1, -1); // ignore: non_constant_identifier_names
  static final DR = Dir( 1, -1); // ignore: non_constant_identifier_names
}