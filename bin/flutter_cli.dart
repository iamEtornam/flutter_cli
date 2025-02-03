import 'dart:io';

import 'package:path/path.dart' as path;

Future<bool> isFlutterInstalled() async {
  try {
    final result = await Process.run('flutter', ['--version']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
}

void main(List<String> arguments) async {
  print('Flutter Project Generator CLI');
  print('----------------------------');

  // Check if Flutter is installed
  if (!await isFlutterInstalled()) {
    print('\n❌ Flutter is not installed or not available in your PATH');
    print('\nPlease follow these steps to install Flutter:');
    print('1. Visit: https://flutter.dev/docs/get-started/install');
    print('2. Download Flutter for your operating system');
    print('3. Extract the downloaded file and add Flutter to your PATH');
    print('4. Run "flutter doctor" to complete the setup');
    print('\nOnce Flutter is installed, run this CLI tool again.');
    exit(1);
  }

  // Get project name
  stdout.write('Enter project name: ');
  final projectName = stdin.readLineSync()?.trim() ?? '';
  if (projectName.isEmpty) {
    print('Error: Project name cannot be empty');
    exit(1);
  }

  // Get bundle ID
  stdout.write('Enter bundle ID (e.g., com.example.app): ');
  final bundleId = stdin.readLineSync()?.trim() ?? '';
  if (bundleId.isEmpty) {
    print('Error: Bundle ID cannot be empty');
    exit(1);
  }

  // Create Flutter project
  print('\nCreating Flutter project...');
  final result = await Process.run('flutter', [
    'create',
    '--org',
    bundleId,
    projectName,
  ]);

  if (result.exitCode != 0) {
    print('Error creating Flutter project: ${result.stderr}');
    exit(1);
  }

  // Change to project directory
  Directory.current = projectName;

  // Create folder structure
  final folders = [
    'lib/components',
    'lib/config',
    'lib/extensions',
    'lib/features',
    'lib/models',
    'lib/resources',
    'lib/routes',
    'lib/services',
    'lib/utils',
    'lib/views',
    'assets',
    'assets/images',
    'assets/fonts',
  ];

  print('\nCreating folder structure...');
  for (final folder in folders) {
    await Directory(folder).create(recursive: true);
    print('Created $folder');

    // Create index files for specific folders
    if (folder.startsWith('lib/') &&
        !folder.startsWith('lib/config') &&
        !folder.startsWith('lib/assets')) {
      final indexFile = File('${folder}/_index.dart');
      await indexFile.writeAsString(
          '// Export all files from ${folder.split('/').last}\n');
      print('Created ${folder}/_index.dart');
    }
  }

  // Update pubspec.yaml to include assets
  final pubspecFile = File('pubspec.yaml');
  var pubspecContent = pubspecFile.readAsStringSync();

  if (!pubspecContent.contains('assets:')) {
    final assetSection = '''
  assets:
    - assets/images/
    - assets/fonts/
''';
    pubspecContent = pubspecContent.replaceFirst(
      'flutter:',
      'flutter:$assetSection',
    );
    pubspecFile.writeAsStringSync(pubspecContent);
    print('\nUpdated pubspec.yaml with assets configuration');
  }

  print('\n✅ Project setup complete!');
  print('To get started, run:');
  print('  cd $projectName');
  print('  flutter pub get');
  print('  flutter run');

  // Install CLI globally
  await installGlobally();
}

Future<void> installGlobally() async {
  try {
    // Get the pub cache bin directory
    final result = await Process.run('dart', ['pub', 'global', 'list']);
    if (result.exitCode != 0) {
      print('\n❌ Error getting pub cache directory');
      return;
    }

    // Add pub cache bin to PATH if not already present
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null) {
      print('\n❌ Could not determine home directory');
      return;
    }

    final pubCacheBin = Platform.isWindows
        ? path.join(home, 'AppData', 'Local', 'Pub', 'Cache', 'bin')
        : path.join(home, '.pub-cache', 'bin');

    // Create shell config file path based on OS
    final shellConfigFile = Platform.isWindows
        ? null
        : File(path.join(home, Platform.isMacOS ? '.zshrc' : '.bashrc'));

    if (!Platform.isWindows && shellConfigFile != null) {
      var configContent = '';
      if (await shellConfigFile.exists()) {
        configContent = await shellConfigFile.readAsString();
      }

      // Add PATH update if not already present
      final pathUpdate = '\nexport PATH="\$PATH:${pubCacheBin}"';
      if (!configContent.contains(pubCacheBin)) {
        await shellConfigFile.writeAsString(pathUpdate, mode: FileMode.append);
        print('\n✅ Added CLI to PATH in ${shellConfigFile.path}');
        print(
            'Please restart your terminal or run: source ${shellConfigFile.path}');
      }
    } else if (Platform.isWindows) {
      // For Windows, use setx command to update PATH
      final currentPath = Platform.environment['PATH'] ?? '';
      if (!currentPath.contains(pubCacheBin)) {
        final result =
            await Process.run('setx', ['PATH', '$currentPath;$pubCacheBin']);
        if (result.exitCode == 0) {
          print('\n✅ Added CLI to PATH');
          print('Please restart your terminal for the changes to take effect');
        }
      }
    }
  } catch (e) {
    print('\n❌ Error installing CLI globally: $e');
  }
}
