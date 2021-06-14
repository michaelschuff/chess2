import 'dart:typed_data';
import 'dart:math' as math;
import 'package:quiver/core.dart' as quiver;

// ignore: camel_case_types
class v2i {
  final Int32List _v2storage;

  /// The components of the vector.
  Int32List get storage => _v2storage;

  /// Set the values of [result] to the minimum of [a] and [b] for each line.
  static void min(v2i a, v2i b, v2i result) {
    result
      ..x = math.min(a.x, b.x)
      ..y = math.min(a.y, b.y);
  }

  /// Set the values of [result] to the maximum of [a] and [b] for each line.
  static void max(v2i a, v2i b, v2i result) {
    result
      ..x = math.max(a.x, b.x)
      ..y = math.max(a.y, b.y);
  }

  /// Construct a new vector with the specified values.
  factory v2i(int x, int y) => v2i.zero()..setValues(x, y);

  /// Initialized with values from [array] starting at [offset].
  factory v2i.array(List<int> array, [int offset = 0]) =>
      v2i.zero()..copyFromArray(array, offset);

  /// Zero vector.
  v2i.zero() : _v2storage = Int32List(2);

  /// Splat [value] into all lanes of the vector.
  factory v2i.all(int value) => v2i.zero()..splat(value);

  /// Copy of [other].
  factory v2i.copy(v2i other) => v2i.zero()..setFrom(other);

  /// Constructs v2 with a given [Float32List] as [storage].
  v2i.fromFloat32List(this._v2storage);

  /// Constructs v2 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float32List.bytesPerElement].
  v2i.fromBuffer(ByteBuffer buffer, int offset)
      : _v2storage = Int32List.view(buffer, offset, 2);

  /// Generate random vector in the range (0, 0) to (1, 1). You can
  /// optionally pass your own random number generator.
  factory v2i.random([math.Random? rng]) {
    rng ??= math.Random();
    return v2i(rng.nextInt(1<<32), rng.nextInt(1<<32));
  }

  /// Set the values of the vector.
  void setValues(int px, int py) {
    _v2storage[0] = px;
    _v2storage[1] = py;
  }

  /// Zero the vector.
  void setZero() {
    _v2storage[0] = 0;
    _v2storage[1] = 0;
  }

  /// Set the values by copying them from [other].
  void setFrom(v2i other) {
    final otherStorage = other._v2storage;
    _v2storage[1] = otherStorage[1];
    _v2storage[0] = otherStorage[0];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(int arg) {
    _v2storage[0] = arg;
    _v2storage[1] = arg;
  }

  /// Returns a printable string
  @override
  String toString() => '[${_v2storage[0]},${_v2storage[1]}]';

  /// Check if two vectors are the same.
  @override
  bool operator ==(Object? other) =>
      (other is v2i) &&
          (_v2storage[0] == other._v2storage[0]) &&
          (_v2storage[1] == other._v2storage[1]);

  @override
  int get hashCode => quiver.hashObjects(_v2storage);

  /// Negate.
  v2i operator -() => clone()..negate();

  /// Subtract two vectors.
  v2i operator -(v2i other) => clone()..sub(other);

  /// Add two vectors.
  v2i operator +(v2i other) => clone()..add(other);

  /// Scale.
  v2i operator /(int scale) => clone()..scale(1 ~/ scale);

  /// Scale.
  v2i operator *(int scale) => clone()..scale(scale);

  /// Access the component of the vector at the index [i].
  int operator [](int i) => _v2storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, int v) {
    _v2storage[i] = v;
  }

  /// Length.
  double get length => math.sqrt(length2);

  /// Length squared.
  int get length2 {
    return _v2storage[0] * _v2storage[0] + _v2storage[1] * _v2storage[1];
  }

  /// Distance from this to [arg]
  double distanceTo(v2i arg) => math.sqrt(distanceToSquared(arg));

  /// Squared distance from this to [arg]
  int distanceToSquared(v2i arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;
    return dx * dx + dy * dy;
  }

  /// Returns the angle between this vector and [other] in radians.
  double angleTo(v2i other) {
    final otherStorage = other._v2storage;
    if (_v2storage[0] == otherStorage[0] && _v2storage[1] == otherStorage[1]) return 0.0;

    final d = dot(other) / (length * other.length);

    return math.acos(d.clamp(-1.0, 1.0));
  }

  /// Returns the signed angle between this and [other] in radians.
  double angleToSigned(v2i other) {
    final otherStorage = other._v2storage;
    if (_v2storage[0] == otherStorage[0] && _v2storage[1] == otherStorage[1]) {
      return 0.0;
    }

    final s = cross(other);
    final c = dot(other);

    return math.atan2(s, c);
  }

  /// Inner product.
  int dot(v2i other) {
    final otherStorage = other._v2storage;
    return _v2storage[0] * otherStorage[0] + _v2storage[1] * otherStorage[1];
  }


  /// Cross product.
  int cross(v2i other) {
    final otherStorage = other._v2storage;
    return _v2storage[0] * otherStorage[1] - _v2storage[1] * otherStorage[0];
  }

  /// Reflect this.
  void reflect(v2i normal) {
    sub(normal.scaled(2 * normal.dot(this)));
  }

  /// Reflected copy of this.
  v2i reflected(v2i normal) => clone()..reflect(normal);

  /// Relative error between this and [correct]
  double relativeError(v2i correct) {
    final correctNorm = correct.length;
    final diffNorm = (this - correct).length;
    return diffNorm / correctNorm;
  }

  /// Absolute error between this and [correct]
  double absoluteError(v2i correct) => (this - correct).length;

  /// True if any component is infinite.
  bool get isInfinite => _v2storage[0].isInfinite || _v2storage[1].isInfinite;

  /// True if any component is NaN.
  bool get isNaN => _v2storage[0].isNaN || _v2storage[1].isNaN;

  /// Add [arg] to this.
  void add(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] + argStorage[0];
    _v2storage[1] = _v2storage[1] + argStorage[1];
  }

  /// Subtract [arg] from this.
  void sub(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] - argStorage[0];
    _v2storage[1] = _v2storage[1] - argStorage[1];
  }

  /// Multiply entries in this with entries in [arg].
  void multiply(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] * argStorage[0];
    _v2storage[1] = _v2storage[1] * argStorage[1];
  }

  /// Int Divide entries in this with entries in [arg].
  void divide(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = _v2storage[0] ~/ argStorage[0];
    _v2storage[1] = _v2storage[1] ~/ argStorage[1];
  }

  /// Scale this by [arg].
  void scale(int arg) {
    _v2storage[1] = _v2storage[1] * arg;
    _v2storage[0] = _v2storage[0] * arg;
  }

  /// Return a copy of this scaled by [arg].
  v2i scaled(int arg) => clone()..scale(arg);

  /// Negate.
  void negate() {
    _v2storage[1] = -_v2storage[1];
    _v2storage[0] = -_v2storage[0];
  }

  /// Absolute value.
  void absolute() {
    _v2storage[1] = _v2storage[1].abs();
    _v2storage[0] = _v2storage[0].abs();
  }

  /// Clamp each entry n in this in the range [min[n]]-[max[n]].
  void clamp(v2i min, v2i max) {
    final minStorage = min.storage;
    final maxStorage = max.storage;
    _v2storage[0] = _v2storage[0].clamp(minStorage[0], maxStorage[0]).toInt();
    _v2storage[1] = _v2storage[1].clamp(minStorage[1], maxStorage[1]).toInt();
  }

  /// Clamp entries this in the range [min]-[max].
  void clampScalar(double min, double max) {
    _v2storage[0] = _v2storage[0].clamp(min, max).toInt();
    _v2storage[1] = _v2storage[1].clamp(min, max).toInt();
  }

  /// Clone of this.
  v2i clone() => v2i.copy(this);

  /// Copy this into [arg]. Returns [arg].
  v2i copyInto(v2i arg) {
    final argStorage = arg._v2storage;
    argStorage[1] = _v2storage[1];
    argStorage[0] = _v2storage[0];
    return arg;
  }

  /// Copies this into [array] starting at [offset].
  void copyIntoArray(List<int> array, [int offset = 0]) {
    array[offset + 1] = _v2storage[1];
    array[offset + 0] = _v2storage[0];
  }

  /// Copies elements from [array] into this starting at [offset].
  void copyFromArray(List<int> array, [int offset = 0]) {
    _v2storage[1] = array[offset + 1];
    _v2storage[0] = array[offset + 0];
  }

  set xy(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[0] = argStorage[0];
    _v2storage[1] = argStorage[1];
  }

  set yx(v2i arg) {
    final argStorage = arg._v2storage;
    _v2storage[1] = argStorage[0];
    _v2storage[0] = argStorage[1];
  }

  set x(int arg) => _v2storage[0] = arg;
  set y(int arg) => _v2storage[1] = arg;
  v2i get xx => v2i(_v2storage[0], _v2storage[0]);
  v2i get xy => v2i(_v2storage[0], _v2storage[1]);
  v2i get yx => v2i(_v2storage[1], _v2storage[0]);
  v2i get yy => v2i(_v2storage[1], _v2storage[1]);
  int get x => _v2storage[0];
  int get y => _v2storage[1];
}