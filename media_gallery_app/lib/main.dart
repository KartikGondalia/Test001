import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/videos_screen.dart';
import 'screens/info_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  bool _isAdmin = false;
  String _userEmail = 'Guest';
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final user = _authService.getCurrentUser();
    setState(() {
      _isSignedIn = user != null;
      _userEmail = user?.email ?? 'Guest';
      // You can set this based on Firestore admin collection
      // For now, only set to true for testing
      _isAdmin = false;
    });
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null) {
        _checkAuthStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  Future<void> _handleSignOut() async {
    await _authService.signOut();
    _checkAuthStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signed out')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Gallery'),
        actions: [
          if (_isSignedIn)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'signout') {
                  _handleSignOut();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'email',
                  enabled: false,
                  child: Text(_userEmail),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'signout',
                  child: Text('Sign Out'),
                ),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(isAdmin: _isAdmin, userEmail: _userEmail),
          const VideosScreen(),
          const InfoScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
