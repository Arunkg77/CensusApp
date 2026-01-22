import 'package:flutter/material.dart';
import 'package:taralabalushishyamandali/users/welcome_screen.dart';
import '../auth/auth_helper.dart';
import '../auth/login_screen.dart';
import 'form_screen.dart';
import 'cards_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // GlobalKey to access CardsScreen state
  final GlobalKey<CardsScreenState> _cardsScreenKey = GlobalKey<CardsScreenState>();

  late final FormScreen _formScreen;
  late final CardsScreen _cardsScreen;
  late final WelcomeScreen _welcomeScreen;

  @override
  void initState() {
    super.initState();
    _formScreen = FormScreen(
      onDataSubmitted: (head, members) {
        // Access CardsScreen state via GlobalKey
        _cardsScreenKey.currentState?.updateData(head, members);
        setState(() {
          _currentIndex = 1; // Switch to cards tab
        });
      },
    );
    _cardsScreen = CardsScreen(key: _cardsScreenKey);
    _welcomeScreen = const WelcomeScreen();
  }

  List<Widget> get _screens => [_formScreen, _cardsScreen, _welcomeScreen];

  Future<void> _logout() async {
    await AuthHelper.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TSM-1108'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _logout();
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              label: 'Fill Form',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'View Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Welcome',
            ),
          ],
        ),
      ),
    );
  }
}