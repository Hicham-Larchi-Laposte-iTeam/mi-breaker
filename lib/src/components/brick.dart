import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:mi_breaker/src/brick_breaker.dart';
import 'package:mi_breaker/src/components/components.dart';
import 'package:mi_breaker/src/config.dart';

class Brick extends RectangleComponent with HasGameReference<BrickBreaker>, CollisionCallbacks {
  Brick({required super.position, required Color color})
    : super(
        size: Vector2(brickWidth, brickHeight),
        anchor: Anchor.center,
        paint:
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
        children: [RectangleHitbox()],
      );

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
    game.score.value++;

    if (other is Ball) {
      if (game.world.children.query<Brick>().length == 1) {
        game.playState = PlayState.won;
        game.world.removeAll(game.world.children.query<Ball>());
        game.world.removeAll(game.world.children.query<Bat>());
      }
    }
  }
}
