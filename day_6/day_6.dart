// https://adventofcode.com/2022/day/6

import 'dart:io';

const String day = '6';
const bool runTest = false;

int calculateStartOfPacketMarker(List<String> datastream, int lengthOfDistinctCharacters) {
  List<String> marker = [];
  int startOfPacketMarker = 0;

  for (int i = 0; i < datastream.length; i++) {
    if (marker.length < lengthOfDistinctCharacters) {
      marker.add(datastream[i]);
    } else {
      // If marker contains all unique values
      if (marker.length == lengthOfDistinctCharacters && marker.toSet().toList().length == lengthOfDistinctCharacters) {
        startOfPacketMarker = i;
        break;
      } else {
        marker.removeAt(0);
        marker.add(datastream[i]);
      }
    }
  }

  return startOfPacketMarker;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<String> datastream = await file.readAsString().then((value) => value.split(''));

  print(calculateStartOfPacketMarker(datastream, 4));
  print(calculateStartOfPacketMarker(datastream, 14));
}
