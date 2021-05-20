import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

class PuzzlePiece extends StatelessWidget {
  PuzzlePiece({
    Key key,
    @required this.image,
    this.points,
    this.imageSize,
  })  : assert(points != null && points.length > 0),
        boundary = _getBounds(points),
        super(key: key);

  final Rect boundary;
  final ui.Image image;
  final List<Offset> points;
  final Size imageSize;

  Size get size => boundary.size;

  @override
  Widget build(BuildContext context) {
    final pixelScale = MediaQuery.of(context).devicePixelRatio;

    return CustomPaint(
      painter: PuzzlePainter(
        image: image,
        boundary: boundary,
        points: points,
        pixelScale: pixelScale,
        elevation: 0,
      ),
      size: size,
    );
  }

  static Rect _getBounds(List<Offset> points) {
    final pointsX = points.map((e) => e.dx);
    final pointsY = points.map((e) => e.dy);
    return Rect.fromLTRB(
      pointsX.reduce(min),
      pointsY.reduce(min),
      pointsX.reduce(max),
      pointsY.reduce(max),
    );
  }
}

class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> points;
  final Rect boundary;
  final double pixelScale;
  final double elevation;

  const PuzzlePainter({
    @required this.image,
    @required this.points,
    @required this.boundary,
    @required this.pixelScale,
    this.elevation = 0,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint();
    final path = getClip(size);
    if (elevation > 0) {
      canvas.drawShadow(path, Colors.black, elevation, false);
    }

    canvas.clipPath(path);
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(boundary.left , boundary.top ,
            boundary.right , boundary.bottom ),
        Rect.fromLTWH(0, 0, boundary.width, boundary.height),
        paint);
  }

  Path getClip(Size size) {
    final path = Path();
    for (var point in points) {
      if (points.indexOf(point) == 0) {
        path.moveTo(point.dx - boundary.left, point.dy - boundary.top);
      } else {
        path.lineTo(point.dx - boundary.left, point.dy - boundary.top);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
