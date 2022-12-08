// https://adventofcode.com/2022/day/8

import 'dart:io';

const String day = '8';
const bool runTest = false;

int visibleTrees(List<List<int>> rows) {
  final int horizontal = rows[0].length;
  final int vertical = rows.length;

  int visibleTrees = 0;

  // All trees on the outside are visible
  visibleTrees += (((vertical - 1) * 2) + ((horizontal - 1) * 2));

  for (int v = 1; v < vertical - 1; v++) {
    for (int h = 1; h < horizontal - 1; h++) {
      bool visibleUp = true;
      bool visibleDown = true;
      bool visibleLeft = true;
      bool visibleRight = true;
      // Check if visible vertical, look up and down
      for (int up = v - 1; up >= 0; up--) {
        if (rows[up][h] >= rows[v][h]) visibleUp = false;

        if (visibleUp == false) break;
      }
      for (int down = v + 1; down < vertical; down++) {
        if (rows[down][h] >= rows[v][h]) visibleDown = false;

        if (visibleDown == false) break;
      }

      // Check if visible horizontal, look left and right
      for (int left = h - 1; left >= 0; left--) {
        if (rows[v][left] >= rows[v][h]) visibleLeft = false;

        if (visibleLeft == false) break;
      }
      for (int right = h + 1; right < horizontal; right++) {
        if (rows[v][right] >= rows[v][h]) visibleRight = false;

        if (visibleRight == false) break;
      }

      if (visibleRight || visibleLeft || visibleDown || visibleUp) visibleTrees += 1;
    }
  }

  return visibleTrees;
}

int scenicScore(List<List<int>> rows) {
  final int horizontal = rows[0].length;
  final int vertical = rows.length;

  int bestScenicScore = 0;

  for (int v = 1; v < vertical - 1; v++) {
    for (int h = 1; h < horizontal - 1; h++) {
      int visibilityUp = 0;
      int visibilityDown = 0;
      int visibilityLeft = 0;
      int visibilityRight = 0;

      // Check vertical scores, look up and down
      for (int up = v - 1; up >= 0; up--) {
        visibilityUp += 1;

        if (rows[up][h] >= rows[v][h]) break;
      }
      for (int down = v + 1; down < vertical; down++) {
        visibilityDown += 1;

        if (rows[down][h] >= rows[v][h]) break;
      }

      // Check if visible horizontal, look left and right
      for (int left = h - 1; left >= 0; left--) {
        visibilityLeft += 1;

        if (rows[v][left] >= rows[v][h]) break;
      }
      for (int right = h + 1; right < horizontal; right++) {
        visibilityRight += 1;

        if (rows[v][right] >= rows[v][h]) break;
      }

      int scenicScore = visibilityLeft * visibilityRight * visibilityDown * visibilityUp;

      if (scenicScore > bestScenicScore) bestScenicScore = scenicScore;
    }
  }

  return bestScenicScore;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<List<int>> rows = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      final numberStrings = line.split('');
      rows.add(
        numberStrings.map((e) => int.parse(e)).toList(),
      );
    });
  });

  print(visibleTrees(rows));
  print(scenicScore(rows));
}
