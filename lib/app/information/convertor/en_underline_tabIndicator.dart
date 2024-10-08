// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


class EnUnderlineTabIndicator extends Decoration {
  const EnUnderlineTabIndicator({
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  final BorderRadius? borderRadius;

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is EnUnderlineTabIndicator) {
      return EnUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is EnUnderlineTabIndicator) {
      return EnUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([ VoidCallback? onChanged ]) {
    return _UnderlinePainter(this, borderRadius, onChanged);
  }

  // Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
  //   final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
  //   return Rect.fromLTWH(
  //     indicator.left,
  //     indicator.bottom - borderSide.width,
  //     indicator.width,
  //     borderSide.width,
  //   );
  // }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double wantWidth = 28;
    double cw = (indicator.left + indicator.right)/2;
    return Rect.fromLTWH(
      cw - wantWidth/2 ,
      indicator.bottom - borderSide.width,
      wantWidth,
      borderSide.width,
    );
  }


  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (borderRadius != null) {
      return Path()..addRRect(
          borderRadius!.toRRect(_indicatorRectFor(rect, textDirection))
      );
    }
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(
      this.decoration,
      this.borderRadius,
      super.onChanged,
      );

  final EnUnderlineTabIndicator decoration;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // assert(configuration.size != null);
    // final Rect rect = offset & configuration.size!;
    // final TextDirection textDirection = configuration.textDirection!;
    // final Paint paint;
    // if (borderRadius != null) {
    //   paint = Paint()..color = decoration.borderSide.color;
    //   final Rect indicator = decoration._indicatorRectFor(rect, textDirection);
    //   final RRect rrect = RRect.fromRectAndCorners(
    //     indicator,
    //     topLeft: borderRadius!.topLeft,
    //     topRight: borderRadius!.topRight,
    //     bottomRight: borderRadius!.bottomRight,
    //     bottomLeft: borderRadius!.bottomLeft,
    //   );
    //   canvas.drawRRect(rrect, paint);
    // } else {
    //   paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
    //   final Rect indicator = decoration._indicatorRectFor(rect, textDirection)
    //       .deflate(decoration.borderSide.width / 2.0);
    //   canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    // }

    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Paint paint;
    if (borderRadius != null) {
      paint = Paint()..color = decoration.borderSide.color;
      final Rect indicator = decoration._indicatorRectFor(rect, textDirection)
          .inflate(decoration.borderSide.width / 4.0);
      final RRect rrect = RRect.fromRectAndCorners(
        indicator,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomRight: borderRadius!.bottomRight,
        bottomLeft: borderRadius!.bottomLeft,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
      final Rect indicator = decoration._indicatorRectFor(rect, textDirection)
          .deflate(decoration.borderSide.width / 2.0);
      canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    }

  }
}
