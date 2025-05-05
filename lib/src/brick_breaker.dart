import 'dart:math' as math;
import 'package:flame/components.dart' show Anchor, CameraComponent;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_breaker/src/components/components.dart';
import 'package:mi_breaker/src/config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker() : super(camera: CameraComponent.withFixedResolution(width: gameWidth, height: gameHeight));

  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(PlayArea());

    playState = PlayState.welcome;

    //  debugMode = true;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    playState = PlayState.playing;
    score.value = 0;

    world.add(
      Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()..scale(height / 4),
      ),
    );

    world.add(
      Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
      ),
    );

    world.addAll([
      for (var row = 0; row < brickMatrix.length; row++)
        for (var col = 0; col < brickMatrix[row].length; col++)
          if (brickMatrix[row][col] != 0)
            Brick(
              position: Vector2(
                (col + 0.5) * brickWidth + (col + 1) * brickGutter,
                (row + 2.0) * brickHeight + (row + 1) * brickGutter,
              ),
              color: brickColors[brickMatrix[row][col] - 1]!,
            ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() => const Color(0xfff2e8cf);
}
