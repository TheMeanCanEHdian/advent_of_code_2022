// https://adventofcode.com/2022/day/3

import 'dart:io';

const String day = '3';
const bool runTest = false;

int partOne(List<String> rucksacks) {
  int prioritySum = 0;

  List<List<String>> rucksackWithCompartments = [];

  rucksacks.forEach((rucksack) {
    List<String> compartments = [];
    compartments.add(
      rucksack.substring(0, rucksack.length ~/ 2),
    );
    compartments.add(
      rucksack.substring(rucksack.length ~/ 2, rucksack.length),
    );

    rucksackWithCompartments.add(compartments);
  });

  rucksackWithCompartments.forEach((rucksack) {
    final commonItem =
        rucksack[0].split('').toSet().where((element) => rucksack[1].split('').contains(element)).toList()[0];

    prioritySum += calculatePriority(commonItem);
  });

  return prioritySum;
}

int partTwo(List<String> rucksacks) {
  int prioritySum = 0;

  List<List<String>> groups = [];

  int count = 0;

  while (count < rucksacks.length) {
    groups.add(rucksacks.sublist(count, count + 3));

    count += 3;
  }

  groups.forEach((group) {
    final commonItem = group[0]
        .split('')
        .toSet()
        .where((element) => group[1].split('').contains(element))
        .toList()
        .where((element) => group[2].split('').contains(element))
        .toList()[0];

    prioritySum += calculatePriority(commonItem);
  });

  return prioritySum;
}

int calculatePriority(String item) {
  final commonItemCharCode = item.codeUnitAt(0);

  // Lowercase charcodes (97 - 122 is a - z)
  // a is a value of 1 and z is a value of 26
  if (commonItemCharCode >= 97 && commonItemCharCode <= 122) {
    return commonItemCharCode - 96;
  }

  // Uppercase charcodes (65 - 90 is A - Z)
  // A is a value of 27 and Z is a value of 52
  if (commonItemCharCode >= 65 && commonItemCharCode <= 90) {
    return commonItemCharCode - 38;
  }

  return 0;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<String> rucksacks = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      rucksacks.add(line);
    });
  });

  print(partOne(rucksacks));

  print(partTwo(rucksacks));
}
