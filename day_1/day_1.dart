// https://adventofcode.com/2022/day/1

import 'dart:io';
import 'dart:math';

const String day = '1';
const bool runTest = false;

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<int> totalCalories = [];

  await file.readAsLines().then((lines) {
    int currentElf = 0;
    lines.forEach((line) {
      if (line == '') {
        totalCalories.add(currentElf);
        currentElf = 0;
      } else if (lines[lines.length - 1] == line) {
        currentElf += int.parse(line);
        totalCalories.add(currentElf);
      } else {
        currentElf += int.parse(line);
      }
    });
  });

  print('Largest Calories: ${totalCalories.reduce(max)}');

  totalCalories.sort(
    (a, b) => a.compareTo(b),
  );

  print(
    'Top 3 Combined Calories: ${totalCalories.sublist(totalCalories.length - 3).reduce((value, element) => value + element)}',
  );
}
