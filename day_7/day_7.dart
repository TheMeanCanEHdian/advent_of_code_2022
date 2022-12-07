// https://adventofcode.com/2022/day/7

import 'dart:io';

const String day = '7';
const bool runTest = false;

/// Creates a map where every entry is a unique directory.
///
/// Every map contains key that: indicate it's parent directory (null when the base directory), indicate it is a type of
/// `dir`, all files contained in the immediate directory, & the size of all files contained in the immediate directory.
///
/// Files contain keys that: indicate it is a type of `file`, and the size of that file.
Map<String, Map<String, dynamic>> createDirectoryMap(List<String> terminalOutput) {
  Map<String, Map<String, dynamic>> directoryMap = {};
  List<String> currentDirectoryPath = [];

  for (String output in terminalOutput) {
    final outputInfo = output.split(' ');

    // If output is a cd command
    if (outputInfo[0] == '\$') {
      if (outputInfo[1] == 'cd') {
        // Remove last entry in currentDirectoryPath when `cd ..`
        if (outputInfo[2] == '..') {
          currentDirectoryPath.removeLast();
        } else {
          if (outputInfo[2] == '/') {
            directoryMap[outputInfo[2]] = {
              'parentDir': null,
              'type': 'dir',
            };
          }

          // Add new entry into currentDirectoryPath when NOT `cd ..`
          currentDirectoryPath.add(outputInfo[2]);
        }
      }
    }
    // If output is not a command then we know its output from an ls command
    else {
      final lsInfo = output.split(' ');

      if (lsInfo[0] == 'dir') {
        if (!directoryMap.containsKey(lsInfo[1])) {
          directoryMap[[...currentDirectoryPath, lsInfo[1]].join('/')] = {
            'parentDir': currentDirectoryPath.length > 1 ? currentDirectoryPath.join('/') : currentDirectoryPath[0],
            'type': 'dir',
          };
        }
      }

      if (lsInfo[0] != 'dir') {
        if (currentDirectoryPath.isEmpty) {
          directoryMap['/']![lsInfo[1]] = {
            'type': 'file',
            'size': int.parse(lsInfo[0]),
          };
        } else {
          directoryMap[currentDirectoryPath.join('/')]![lsInfo[1]] = {
            'type': 'file',
            'size': int.parse(lsInfo[0]),
          };
        }
      }
    }
  }

  // Process each directory and create a size key that is the size of all files in the immediate directory
  // (not including nested)
  final directories = directoryMap.keys;

  for (String directory in directories) {
    int size = 0;

    directoryMap[directory]!.forEach((key, value) {
      if (!['parentDir', 'type'].contains(key) && directoryMap[directory]![key]['type'] == 'file') {
        size += directoryMap[directory]![key]['size'] as int;
      }
    });

    directoryMap[directory]!['size'] = size;
  }

  return directoryMap;
}

/// Uses recursion to parse the directoryMap and find all directories that children of the starting directory.
///
/// `directoryList` needs to be prepopulated with a single directory. It will then have additional directories added
/// as nested directories are discovered.
List<String> getNestedDirectories(List<String> directoryList, Map<String, Map<String, dynamic>> directoryMap) {
  List<String> newDirectories = [...directoryList];

  directoryMap.keys.forEach((key) {
    if (!newDirectories.contains(key) && directoryList.contains(directoryMap[key]!['parentDir'])) {
      newDirectories.add(key);
    }
  });

  if (newDirectories.length != directoryList.length) {
    return getNestedDirectories(newDirectories, directoryMap);
  }

  return newDirectories;
}

main() async {
  final File file = File('${Directory.current.path}\\day_${day}\\${runTest ? "test" : "input"}.txt');

  List<String> terminalOutput = [];

  await file.readAsLines().then((lines) {
    lines.forEach((line) {
      terminalOutput.add(line);
    });
  });

  Map<String, Map<String, dynamic>> directoryMap = createDirectoryMap(terminalOutput);

  //! Part One

  int partOneSize = 0;

  // Find all directories with a size of `100000` or less and add their size (the size of all files in the immediate
  // directory) to the total size
  directoryMap.keys.forEach((directory) {
    final directoryList = getNestedDirectories([directory], directoryMap);

    int size = 0;
    directoryList.forEach((key) {
      size += directoryMap[key]!['size'] as int;
    });

    if (size <= 100000) partOneSize += size;
  });

  print(partOneSize);

  //! Part 2
  int? sizeOfDirectoryToDelete;

  // Get the total size of all directories
  final directoryList = getNestedDirectories(['/'], directoryMap);
  int totalSize = 0;
  directoryList.forEach((key) {
    totalSize += directoryMap[key]!['size'] as int;
  });

  // Calculate how much data needs to be deleted to run the update
  const int filesystemSize = 70000000;
  const int updateSize = 30000000;
  final int spaceNeeded = updateSize - (filesystemSize - totalSize);

  // Parse each directory to find the smallest one that is larger or equal to spaceNeeded
  directoryMap.keys.forEach((directory) {
    final directoryList = getNestedDirectories([directory], directoryMap);

    int size = 0;
    directoryList.forEach((key) {
      size += directoryMap[key]!['size'] as int;
    });

    if (sizeOfDirectoryToDelete == null) {
      sizeOfDirectoryToDelete = size;
    } else if (size >= spaceNeeded && size < sizeOfDirectoryToDelete!) {
      sizeOfDirectoryToDelete = size;
    }
  });

  print(sizeOfDirectoryToDelete);
}
