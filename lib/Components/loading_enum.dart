import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

part 'loading_enum.g.dart';

@HiveType(typeId: 40)
enum LoadingWidget {
  @HiveField(0)
  newtonCradle,
  @HiveField(1)
  inkDrop,
  @HiveField(2)
  halfTriangleDot,
  @HiveField(3)
  waveDots,
  @HiveField(4)
  staggeredDotsWave,
  @HiveField(5)
  threeRotatingDots,
}

extension LoadingWidgetExtension on LoadingWidget {
  Color get color => Colors.white;
  double get size => 50;

  Widget get widget {
    switch (this) {
      case LoadingWidget.newtonCradle:
        return LoadingAnimationWidget.newtonCradle(
          color: color,
          size: size,
        );
      case LoadingWidget.inkDrop:
        return LoadingAnimationWidget.inkDrop(
          color: color,
          size: size,
        );
      case LoadingWidget.halfTriangleDot:
        return LoadingAnimationWidget.halfTriangleDot(
          color: color,
          size: size,
        );
      case LoadingWidget.staggeredDotsWave:
        return LoadingAnimationWidget.staggeredDotsWave(
          color: color,
          size: size,
        );
      case LoadingWidget.threeRotatingDots:
        return LoadingAnimationWidget.threeRotatingDots(
          color: color,
          size: size,
        );
      case LoadingWidget.waveDots:
        return LoadingAnimationWidget.waveDots(
          color: color,
          size: size,
        );
      case _:
        return CircularProgressIndicator();
    }
  }
}
