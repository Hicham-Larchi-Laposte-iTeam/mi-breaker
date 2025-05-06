import 'package:flutter/material.dart';

const brickMatrix = [
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 0, 0, 0, 0, 0],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 0, 0, 0],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 0],
  [1, 1, 1, 0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2],
  [1, 1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2],
  [1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 0, 0, 2, 2, 2, 2, 2],
  [1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 2, 0, 0, 2],
];

const bricksCount = 98;

const brickColors = [
  Color(0xff664B3B), // Color 1
  Color(0xffc9bb8f), // Color 2
  null, // Empty space
];

const gameWidth = 820.0;
const gameHeight = 1600.0;
const ballRadius = gameWidth * 0.02;
const batWidth = gameWidth * 0.2;
const batHeight = ballRadius * 2;
const batStep = gameWidth * 0.05;
const brickGutter = gameWidth * 0.015;
final brickWidth = (gameWidth - (brickGutter * (brickMatrix[0].length + 1))) / brickMatrix[0].length;
const brickHeight = gameHeight * 0.03;
const difficultyModifier = 1.01;
