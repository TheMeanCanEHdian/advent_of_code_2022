// https://adventofcode.com/2022/day/4

import 'dart:io';

const String day = '4';
const bool runTest = false;

int partOne(List<String> assignemntPairs) {
  int fullyContainedPairs = 0;

  assignemntPairs.forEach((pair) {
    final splitPairs = pair.split(',');

    final pairOne = splitPairs[0].split('-').map((e) => int.parse(e)).toList();
    final pairTwo = splitPairs[1].split('-').map((e) => int.parse(e)).toList();

    // Pair two inside pair one or pair one inside pair two
    if ((pairOne[0] <= pairTwo[0] && pairOne[1] >= pairTwo[1] ||
        (pairTwo[0] <= pairOne[0] && pairTwo[1] >= pairOne[1]))) {
      fullyContainedPairs += 1;
    }
  });

  return fullyContainedPairs;
}

int partTwo(List<String> assignemntPairs) {
  int partiallyContainedPairs = 0;

  assignemntPairs.forEach((pair) {
    final splitPairs = pair.split(',');

    final pairOne = splitPairs[0].split('-').map((e) => int.parse(e)).toList();
    final pairTwo = splitPairs[1].split('-').map((e) => int.parse(e)).toList();

    var pairOneValues = [for (var i = pairOne[0]; i <= pairOne[1]; i++) i];
    var pairTwoValues = [for (var i = pairTwo[0]; i <= pairTwo[1]; i++) i];

    final intersection = pairOneValues.toSet().intersection(pairTwoValues.toSet());

    if (intersection.isNotEmpty) partiallyContainedPairs += 1;
  });

  return partiallyContainedPairs;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<String> assignemntPairs = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      assignemntPairs.add(line);
    });
  });

  print(partOne(assignemntPairs));
  print(partTwo(assignemntPairs));
}
