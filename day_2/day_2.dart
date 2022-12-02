// https://adventofcode.com/2022/day/2

import 'dart:io';

const String day = '2';
const bool runTest = false;

int partOneScore(Map<String, int> uniqueRounds) {
  int finalScore = 0;

  uniqueRounds.forEach((roundMoves, occurancesOfRound) {
    // Played Rock
    if (roundMoves.endsWith('X')) {
      finalScore += 1 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 3 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 0 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 6 * occurancesOfRound;
    }

    // Played Paper
    if (roundMoves.endsWith('Y')) {
      finalScore += 2 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 6 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 3 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 0 * occurancesOfRound;
    }

    // Played Scissors
    if (roundMoves.endsWith('Z')) {
      finalScore += 3 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 0 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 6 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 3 * occurancesOfRound;
    }
  });

  return finalScore;
}

int partTwoScore(Map<String, int> uniqueRounds) {
  int finalScore = 0;

  uniqueRounds.forEach((roundMoves, occurancesOfRound) {
    // Need to lose
    if (roundMoves.endsWith('X')) {
      finalScore += 0 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 3 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 1 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 2 * occurancesOfRound;
    }

    // Need to draw
    if (roundMoves.endsWith('Y')) {
      finalScore += 3 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 1 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 2 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 3 * occurancesOfRound;
    }

    // Need to win
    if (roundMoves.endsWith('Z')) {
      finalScore += 6 * occurancesOfRound;

      if (roundMoves.startsWith('A')) finalScore += 2 * occurancesOfRound;
      if (roundMoves.startsWith('B')) finalScore += 3 * occurancesOfRound;
      if (roundMoves.startsWith('C')) finalScore += 1 * occurancesOfRound;
    }
  });

  return finalScore;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<String> rounds = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      rounds.add(line);
    });
  });

  // A map where the key representes the round and the value is the number of times that identical round is played
  final uniqueRounds = rounds.fold(
    <String, int>{},
    (map, item) => map..update(item, (count) => count + 1, ifAbsent: () => 1),
  );

  print(partOneScore(uniqueRounds));
  print(partTwoScore(uniqueRounds));
}
