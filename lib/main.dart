import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/book_provider.dart';
import 'providers/reading_note_provider.dart';
import 'repositories/book_repository.dart';
import 'repositories/reading_note_repository.dart';
import 'services/book_api_service.dart';
import 'services/reading_note_service.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const BookNestApp());
}


class BookNestApp extends StatelessWidget {
  const BookNestApp({
    super.key,
    this.readingNoteRepository,
  });

  final ReadingNoteRepository? readingNoteRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BookApiService>(
          create: (_) => BookApiService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<BookRepository>(
          create: (context) => BookRepository(
            apiService: context.read<BookApiService>(),
          ),
        ),
        ChangeNotifierProvider<BookProvider>(
          create: (context) => BookProvider(
            repository: context.read<BookRepository>(),
          ),
        ),
        Provider<ReadingNoteService>(
          create: (_) => ReadingNoteService(),
        ),
        Provider<ReadingNoteRepository>(
          create: (context) =>
              readingNoteRepository ??
              ReadingNoteRepository(
                service: context.read<ReadingNoteService>(),
              ),
        ),
        ChangeNotifierProvider<ReadingNoteProvider>(
          create: (context) => ReadingNoteProvider(
            repository: context.read<ReadingNoteRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'BookNest',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF496A81),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F8FC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF5F8FC),
            foregroundColor: Color(0xFF173B57),
            elevation: 0,
            centerTitle: false,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onExploreTap: () => _selectTab(1)),
      const ExploreScreen(),
      const LibraryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'My Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
