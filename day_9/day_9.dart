// https://adventofcode.com/2022/day/9

import 'dart:io';

const String day = '9';
const bool runTest = false;

bool isTailTouchingHead(List<int> headLocation, List<int> tailLocation) {
  bool tailSameSpot = (tailLocation[0] == headLocation[0]) && (tailLocation[1] == headLocation[1]);

  bool tailOnLeft = (tailLocation[1] == headLocation[1] - 1) && (tailLocation[0] == headLocation[0]);
  bool tailOnRight = (tailLocation[1] == headLocation[1] + 1) && (tailLocation[0] == headLocation[0]);
  bool tailOnTop = (tailLocation[0] == headLocation[0] - 1) && (tailLocation[1] == headLocation[1]);
  bool tailOnBottom = (tailLocation[0] == headLocation[0] + 1) && (tailLocation[1] == headLocation[1]);

  bool tailOnTopLeft = (tailLocation[0] == headLocation[0] - 1) && (tailLocation[1] == headLocation[1] - 1);
  bool tailOnTopRight = (tailLocation[0] == headLocation[0] - 1) && (tailLocation[1] == headLocation[1] + 1);
  bool tailOnBottomLeft = (tailLocation[0] == headLocation[0] + 1) && (tailLocation[1] == headLocation[1] - 1);
  bool tailOnBottomRight = (tailLocation[0] == headLocation[0] + 1) && (tailLocation[1] == headLocation[1] + 1);

  return tailSameSpot ||
      tailOnLeft ||
      tailOnRight ||
      tailOnTop ||
      tailOnBottom ||
      tailOnTopLeft ||
      tailOnTopRight ||
      tailOnBottomLeft ||
      tailOnBottomRight;
}

List<List<int>> updateLocationsTailVisited(List<List<int>> visitedLocations, List<int> tailLocation) {
  List<List<int>> updatedLocations = [...visitedLocations];

  bool locationAlreadyVisited = false;
  for (List<int> location in updatedLocations) {
    if (location[0] == tailLocation[0] && location[1] == tailLocation[1]) {
      locationAlreadyVisited = true;
      break;
    }
  }

  if (!locationAlreadyVisited) {
    updatedLocations.add([...tailLocation]);
  }

  return updatedLocations;
}

List<List<List<int>>> moveTrailingKnots(
  List<List<int>> knotLocations,
  List<List<int>> visitedLocations,
) {
  final tailIndex = knotLocations.length - 1;

  // For each knot
  for (int k = 0; k < tailIndex; k++) {
    // If knot isn't touching iterate through knots moving them to the position left by the knot that just moved
    if (!isTailTouchingHead(knotLocations[k], knotLocations[k + 1])) {
      // Diagonal Move
      if ((knotLocations[k][0] != knotLocations[k + 1][0]) && (knotLocations[k][1] != knotLocations[k + 1][1])) {
        bool verticalDiffIsNegative = (knotLocations[k][0] - knotLocations[k + 1][0]).isNegative;
        bool horizontalDiffIsNegative = (knotLocations[k][1] - knotLocations[k + 1][1]).isNegative;

        if (verticalDiffIsNegative) {
          knotLocations[k + 1][0] -= 1;
        } else {
          knotLocations[k + 1][0] += 1;
        }

        if (horizontalDiffIsNegative) {
          knotLocations[k + 1][1] -= 1;
        } else {
          knotLocations[k + 1][1] += 1;
        }
      } else if (knotLocations[k][0] != knotLocations[k + 1][0]) {
        // Row isn't same
        bool verticalDiffIsNegative = (knotLocations[k][0] - knotLocations[k + 1][0]).isNegative;

        if (verticalDiffIsNegative) {
          knotLocations[k + 1][0] -= 1;
        } else {
          knotLocations[k + 1][0] += 1;
        }
      } else if (knotLocations[k][1] != knotLocations[k + 1][1]) {
        // Column isn't same
        bool horizontalDiffIsNegative = (knotLocations[k][1] - knotLocations[k + 1][1]).isNegative;

        if (horizontalDiffIsNegative) {
          knotLocations[k + 1][1] -= 1;
        } else {
          knotLocations[k + 1][1] += 1;
        }
      }

      if (tailIndex == (k + 1)) {
        visitedLocations = updateLocationsTailVisited(visitedLocations, knotLocations[k + 1]);
      }
    } else {
      break;
    }
  }

  return [knotLocations, visitedLocations];
}

int moveKnots({
  required List<Map<String, int>> commands,
  required int numOfKnots,
}) {
  List<List<int>> visitedLocations = [];
  List<List<int>> knotLocations = [];

  for (int i = 0; i < numOfKnots; i++) {
    knotLocations.add([0, 0]);
  }

  commands.forEach((command) {
    final direction = command.keys.first;
    final value = command[direction]!;

    if (direction == 'R') {
      // For each move in direction
      for (int i = 0; i < value; i++) {
        // Move head knot
        knotLocations[0][1] += 1;

        final result = moveTrailingKnots(knotLocations, visitedLocations);
        knotLocations = result[0];
        visitedLocations = result[1];
      }
    }
    if (direction == 'L') {
      // For each move in direction
      for (int i = 0; i < value; i++) {
        // Move head knot
        knotLocations[0][1] -= 1;

        final result = moveTrailingKnots(knotLocations, visitedLocations);
        knotLocations = result[0];
        visitedLocations = result[1];
      }
    }
    if (direction == 'U') {
      // For each move in direction
      for (int i = 0; i < value; i++) {
        // Move head knot
        knotLocations[0][0] -= 1;

        final result = moveTrailingKnots(knotLocations, visitedLocations);
        knotLocations = result[0];
        visitedLocations = result[1];
      }
    }
    if (direction == 'D') {
      // For each move in direction
      for (int i = 0; i < value; i++) {
        // Move head knot
        knotLocations[0][0] += 1;

        final result = moveTrailingKnots(knotLocations, visitedLocations);
        knotLocations = result[0];
        visitedLocations = result[1];
      }
    }
  });

  return visitedLocations.length + 1;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<Map<String, int>> commands = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      final lineSplit = line.split(' ');
      commands.add({
        lineSplit[0]: int.parse(lineSplit[1]),
      });
    });
  });

  //! Part One
  print(moveKnots(commands: commands, numOfKnots: 2));

  //! Part Two
  print(moveKnots(commands: commands, numOfKnots: 10));
}
