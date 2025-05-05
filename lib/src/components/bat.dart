import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';
import 'package:mi_breaker/src/brick_breaker.dart';
import 'package:mi_breaker/src/config.dart';

class Bat extends PositionComponent with DragCallbacks, HasGameReference<BrickBreaker> {
  Bat({required this.cornerRadius, required super.size, required super.position})
    : super(anchor: Anchor.center, children: [RectangleHitbox()]);

  final Radius cornerRadius;

  final Paint _paint =
      Paint()
        ..color = const Color(0xff1e6091)
        ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size.toSize(), cornerRadius), _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  void moveBy(double dx) {
    add(MoveToEffect(Vector2((position.x + dx).clamp(0, gameWidth), position.y), EffectController(duration: 0.1)));
  }
}
