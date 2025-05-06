import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:mi_breaker/src/brick_breaker.dart';
import 'package:mi_breaker/src/components/components.dart';

class Ball extends CircleComponent with HasGameReference<BrickBreaker>, CollisionCallbacks {
  Ball({required Vector2 velocity, required super.position, required double radius, required this.difficultyModifier})
    : velocity = velocity.clone(),
      super(
        radius: radius,
        anchor: Anchor.center,
        paint:
            Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
        children: [CircleHitbox()],
      );

  late final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Ensure the ball doesn't skip collisions by clamping its position within bounds
    // Cache game.size to avoid repeated lookups
    final gameSize = game.size;
    if (position.x - radius < 0) {
      position.x = radius;
      velocity.x = -velocity.x;
    } else if (position.x + radius > gameSize.x) {
      position.x = gameSize.x - radius;
      velocity.x = -velocity.x;
    }

    if (position.y - radius < 0) {
      position.y = radius;
      velocity.y = -velocity.y;
    } else if (position.y + radius > gameSize.y) {
      add(
        RemoveEffect(
          delay: 0.35,
          onComplete: () {
            game.playState = PlayState.gameOver;
          },
        ),
      );
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x + (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }

      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
