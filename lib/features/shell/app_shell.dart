import 'package:flutter/material.dart';

import '../../l10n/l10n_x.dart';
import '../body/body_screen.dart';
import '../journal/journal_screen.dart';
import '../path/path_screen.dart';
import '../study/study_screen.dart';
import '../today/today_screen.dart';

/// The five tabs. The practice runner is deliberately *not* one of them: it
/// is pushed full-screen with no navigation bar, because nothing should
/// compete with it while someone is on the mat.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          TodayScreen(),
          StudyScreen(),
          JournalScreen(),
          BodyScreen(),
          PathScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.radio_button_unchecked),
            selectedIcon: const Icon(Icons.trip_origin),
            label: l.navToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l.navStudy,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border),
            selectedIcon: const Icon(Icons.bookmark),
            label: l.navJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.accessibility_new_outlined),
            selectedIcon: const Icon(Icons.accessibility_new),
            label: l.navBody,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l.navPath,
          ),
        ],
      ),
    );
  }
}
