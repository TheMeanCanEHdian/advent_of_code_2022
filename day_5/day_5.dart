// https://adventofcode.com/2022/day/5

import 'dart:io';

const String day = '5';
const bool runTest = false;

String moveCrates({
  required Map<int, List<String>> crateStacks,
  required List<List<int>> proceedures,
  required int crateStacksCount,
  bool reversed = false,
}) {
  // Move crates (not working to manipulate an existing list while iterating over it so replacing with new constructed lists)
  for (int i = 0; i < proceedures.length; i++) {
    int numberOfCrateToMove = proceedures[i][0];
    int sourceStack = proceedures[i][1];
    int destinationStack = proceedures[i][2];

    late List<String> cratesToMove;

    if (reversed) {
      cratesToMove = crateStacks[sourceStack]!.sublist(0, numberOfCrateToMove).reversed.toList();
    } else {
      cratesToMove = crateStacks[sourceStack]!.sublist(0, numberOfCrateToMove);
    }

    // Add crate to destination stack
    crateStacks[destinationStack] = cratesToMove + crateStacks[destinationStack]!;

    // Remove crate from source stack
    crateStacks[sourceStack] = crateStacks[sourceStack]!.sublist(numberOfCrateToMove);
  }

  String topOfEachStack = '';
  for (int i = 0; i < crateStacksCount; i++) {
    topOfEachStack += crateStacks[i + 1]![0];
  }

  return topOfEachStack;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  int endOfCrates = 0;
  int crateStacksCount = 0;

  Map<int, List<String>> crateStacks = {};
  List<List<int>> proceedures = [];

  await file.readAsLines().then((lines) {
    for (int i = 0; i < lines.length; i++) {
      // Determine where in the file the crates diagram ends
      if (lines[i] == '') {
        endOfCrates = i - 1;
        break;
      }
    }

    // Determine how many crate stacks exist
    for (int i = 0; i < lines[endOfCrates].length; i++) {
      final value = int.tryParse(lines[endOfCrates][i]);
      if (value != null) {
        crateStacksCount = value;
      }
    }

    // Build crate stacks
    // For each crate row
    for (int i = 0; i < endOfCrates; i++) {
      int index = 0;
      // For each stack
      for (int j = 0; j < crateStacksCount; j++) {
        // Make substrings for each "crate"
        String crate = lines[i].substring(index, index + 3).replaceAll('[', '').replaceAll(']', '').trim();

        // Add crate to crackeStacks
        if (crate != '') {
          if (!crateStacks.containsKey(j + 1)) {
            crateStacks[j + 1] = [];
          }
          crateStacks[j + 1]!.add(crate);
        }

        index += 4;
      }
    }

    // Build movement list
    for (int i = endOfCrates + 2; i < lines.length; i++) {
      final splitString = lines[i].split(' ');
      final proceedure = [int.parse(splitString[1]), int.parse(splitString[3]), int.parse(splitString[5])];
      proceedures.add(proceedure);
    }
  });

  // Part One
  print(
    moveCrates(
      crateStacks: Map.from(crateStacks),
      proceedures: proceedures,
      crateStacksCount: crateStacksCount,
      reversed: true,
    ),
  );

  // Part Two
  print(
    moveCrates(
      crateStacks: Map.from(crateStacks),
      proceedures: proceedures,
      crateStacksCount: crateStacksCount,
      reversed: false,
    ),
  );
}
