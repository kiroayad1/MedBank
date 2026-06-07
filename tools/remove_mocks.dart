#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';

/// ---------------------------------------------------------------------------
/// Medicine Bank — Mock Data Removal Script
/// ---------------------------------------------------------------------------
///
/// PURPOSE:
///   When the backend API is fully ready, run this script to strip all
///   mock/dummy implementations from the codebase and force the app to
///   use only real API repositories.
///
/// WHAT IT DOES:
///   1. Deletes every `*_mock_repository.dart` file under `lib/`.
///   2. Rewrites every `*_repository_provider.dart` to always return
///      the API repository (removes the `ApiConfig.useLiveBackend` toggle).
///   3. Optionally deletes `ApiConfig.useLiveBackend` from `api_config.dart`.
///   4. Runs `flutter analyze` and prints a summary.
///
/// USAGE:
///   dart tools/remove_mocks.dart
///
/// SAFETY:
///   - This script only touches files matching known mock patterns.
///   - It prints every file it deletes or modifies.
///   - It does NOT delete model files, screens, or providers.
///   - It does NOT push to git. Review changes with `git diff` before committing.
/// ---------------------------------------------------------------------------

const _providerPattern =
    r'''if \(ApiConfig\.useLiveBackend\) \{\s*return\s+(\w+)\(\);\s*\}\s*return\s+(\w+)\(\);'''; // rough regex for detection

void main(List<String> args) {
  final dryRun = args.contains('--dry-run');
  final keepToggle = args.contains('--keep-toggle');

  print('=' * 70);
  print('Medicine Bank — Mock Data Removal Tool');
  print('=' * 70);
  if (dryRun) {
    print('MODE: DRY RUN (no files will be changed)');
  }
  print('');

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('ERROR: Could not find "lib" directory.');
    print('Make sure you run this script from the project root.');
    exit(1);
  }

  // -------------------------------------------------------------------------
  // STEP 1: Delete mock repository files
  // -------------------------------------------------------------------------
  print('STEP 1: Searching for *_mock_repository.dart files...');
  final mockFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_mock_repository.dart'))
      .toList();

  if (mockFiles.isEmpty) {
    print('  No mock repository files found.');
  } else {
    for (final file in mockFiles) {
      final rel = file.path.replaceAll(r'\', '/');
      print('  DELETE  $rel');
      if (!dryRun) file.deleteSync();
    }
    print('  Deleted ${mockFiles.length} file(s).');
  }
  print('');

  // -------------------------------------------------------------------------
  // STEP 2: Rewrite repository providers
  // -------------------------------------------------------------------------
  print('STEP 2: Rewriting repository providers to use API only...');
  final providerFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_repository_provider.dart'))
      .toList();

  int providersUpdated = 0;
  for (final file in providerFiles) {
    final content = file.readAsStringSync();
    final rel = file.path.replaceAll(r'\', '/');

    // Check if it still has the conditional logic
    if (!content.contains('ApiConfig.useLiveBackend')) {
      print('  SKIP    $rel (already clean)');
      continue;
    }

    // We need to rewrite the provider body to always return the API repo.
    // This is a simple regex-based replacement. It assumes the standard
    // pattern we generated:
    //
    //   if (ApiConfig.useLiveBackend) {
    //     return MedicineApiRepository();
    //   }
    //   return MedicineMockRepository();
    //
    // We want to keep only:
    //
    //   return MedicineApiRepository();
    //
    final newContent = content.replaceAllMapped(
      RegExp(
        r'if\s*\(\s*ApiConfig\.useLiveBackend\s*\)\s*\{\s*return\s+(\w+)\(\);\s*\}\s*return\s+\w+\(\);',
        multiLine: true,
      ),
      (match) => 'return ${match.group(1)}();',
    );

    // Also remove the unused import if it was only used for the toggle
    final cleaned = newContent.replaceAll(
      RegExp(r"import\s+'package:.*api_config\.dart';\n"),
      '',
    );

    print('  UPDATE  $rel');
    if (!dryRun) file.writeAsStringSync(cleaned);
    providersUpdated++;
  }
  print('  Updated $providersUpdated provider(s).');
  print('');

  // -------------------------------------------------------------------------
  // STEP 3: Optionally remove ApiConfig.useLiveBackend
  // -------------------------------------------------------------------------
  if (!keepToggle) {
    print('STEP 3: Removing ApiConfig.useLiveBackend from api_config.dart...');
    final apiConfig = File('lib/core/network/api_config.dart');
    if (apiConfig.existsSync()) {
      final content = apiConfig.readAsStringSync();
      final newContent = content.replaceAllMapped(
        RegExp(
          r"\n\s*/// Master toggle.*\n\s*static const bool useLiveBackend = bool\.fromEnvironment\(\s*'USE_LIVE_BACKEND',\s*defaultValue: false,\s*\);",
          multiLine: true,
          dotAll: true,
        ),
        (match) => '',
      );
      print('  UPDATE  lib/core/network/api_config.dart');
      if (!dryRun) apiConfig.writeAsStringSync(newContent);
    } else {
      print('  WARNING lib/core/network/api_config.dart not found');
    }
    print('');
  } else {
    print('STEP 3: SKIPPED (--keep-toggle flag set)');
    print('');
  }

  // -------------------------------------------------------------------------
  // STEP 4: Verify with flutter analyze
  // -------------------------------------------------------------------------
  print('STEP 4: Running flutter analyze...');
  if (dryRun) {
    print('  SKIPPED in dry-run mode.');
  } else {
    final result = Process.runSync('flutter', ['analyze'], runInShell: true);
    final output = result.stdout.toString();
    final errors = output.contains('error') || output.contains('Error');
    if (errors) {
      print('  WARNING: Errors detected! Review output below:');
      print(output);
    } else {
      print('  PASSED  No errors found.');
    }
  }
  print('');

  // -------------------------------------------------------------------------
  // SUMMARY
  // -------------------------------------------------------------------------
  print('=' * 70);
  print('SUMMARY');
  print('=' * 70);
  print('Mock files deleted:  ${mockFiles.length}');
  print('Providers updated:   $providersUpdated');
  if (!keepToggle) print('ApiConfig toggle:    Removed');
  print('');
  print('NEXT STEPS:');
  print('  1. Review changes:   git diff');
  print('  2. Run the app:      flutter run --dart-define=API_BASE_URL=<url>');
  print('  3. Run tests:        flutter test');
  print(
    '  4. Commit when ready: git add . && git commit -m "chore: remove mocks"',
  );
  print('');
}
