// https://adventofcode.com/2022/day/10

import 'dart:io';

enum CodeExecution {
  signalStrength,
  drawCrt,
}

const String day = '10';
const bool runTest = false;

void clockCycle(List<List<String>> instructions, CodeExecution codeExecution) {
  List<List<String>> instructionsToExecute = [...instructions];
  // buffer key is cycle to execute, value is amount to add to register
  Map<int, int?> buffer = {};
  int register = 1;
  int currentCycle = 1;

  int signalStrength = 0;
  List<List<String>> crtRows = [];

  while (instructionsToExecute.length > 0 || buffer.entries.length > 0) {
    //! Start Cycle
    // Check for instruction to execute ONLY if no active executions this cycle (instructions set to conclude next cycle)
    if (!buffer.containsKey(currentCycle + 1) && instructionsToExecute.length > 0) {
      if (instructionsToExecute[0][0] == 'noop') {
        buffer[currentCycle + 1] = null;
        instructionsToExecute.removeAt(0);
      } else if (instructionsToExecute[0][0] == 'addx') {
        buffer[currentCycle + 2] = int.parse(instructionsToExecute[0][1]);
        instructionsToExecute.removeAt(0);
      }
    }

    //! During Cycle
    switch (codeExecution) {
      case CodeExecution.signalStrength:
        // On cycle 20 and every 40 cycles after
        if (currentCycle == 20 || ((currentCycle - 20) % 40 == 0)) {
          signalStrength += (currentCycle * register);
        }
        break;
      case CodeExecution.drawCrt:
        late int currentRow = (currentCycle / 40).floor();
        late int drawingPosition;

        // Adjust currentRow logic for the last cycle of each row
        if (currentCycle % 40 == 0) currentRow -= 1;

        // Use different calculations for drawingPosition when cycle is over 40
        if (currentCycle <= 40) {
          drawingPosition = currentCycle - 1;
        } else {
          drawingPosition = (currentCycle - (40 * currentRow)) - 1;
        }

        // Add new CRT rows as needed
        if (crtRows.length - 1 < currentRow) {
          crtRows.add([]);
        }

        // Draw on CRT
        if ([register - 1, register, register + 1].contains(drawingPosition)) {
          crtRows[currentRow].add('#');
        } else {
          crtRows[currentRow].add('.');
        }
        break;
    }

    //! End Cycle
    currentCycle += 1;

    //! After Cycle
    // Execute buffered instruction
    if (buffer.containsKey(currentCycle)) {
      if (buffer[currentCycle] != null) {
        register += buffer[currentCycle]!;
      }

      buffer.remove(currentCycle);
    }
  }

  switch (codeExecution) {
    case CodeExecution.signalStrength:
      print(signalStrength);
      break;
    case CodeExecution.drawCrt:
      crtRows.forEach((row) {
        print(row.join());
      });
      break;
  }
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<List<String>> instructions = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      instructions.add(line.split(' '));
    });
  });

  clockCycle(instructions, CodeExecution.signalStrength);
  print('---');
  clockCycle(instructions, CodeExecution.drawCrt);
}
