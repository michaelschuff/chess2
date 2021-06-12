import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Piece {
  final String mColor;
  final String mType;
  final String mImagePath;

  const Piece(this.mColor, this.mType, this.mImagePath);

  String get color => mColor;
  String get type => mType;
  String get name => mColor + mType;
  String get imagePath => mImagePath;
  SvgPicture get image => SvgPicture.asset(mImagePath, fit: BoxFit.fitWidth);


  static const Piece wp = const Piece("w", "p", "assets/images/wp.svg");
  static const Piece wr = const Piece("w", "r", "assets/images/wr.svg");
  static const Piece wn = const Piece("w", "n", "assets/images/wn.svg");
  static const Piece wb = const Piece("w", "b", "assets/images/wb.svg");
  static const Piece wq = const Piece("w", "q", "assets/images/wq.svg");
  static const Piece wk = const Piece("w", "k", "assets/images/wk.svg");
  static const Piece bp = const Piece("b", "p", "assets/images/bp.svg");
  static const Piece br = const Piece("b", "r", "assets/images/br.svg");
  static const Piece bn = const Piece("b", "n", "assets/images/bn.svg");
  static const Piece bb = const Piece("b", "b", "assets/images/bb.svg");
  static const Piece bq = const Piece("b", "q", "assets/images/bq.svg");
  static const Piece bk = const Piece("b", "k", "assets/images/bk.svg");
  static const Piece none = const Piece(" ", " ", "assets/images/  .svg");
}