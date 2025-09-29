import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// --- CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF1F41BB);
const Color kHeaderTextColor = Color(0xFF666666);
const Color kLightFieldColor = Color(0xFFF1F4FF);
const Color kLightBackgroundColor = Color(0xFFF9FAFD);
const Color kCardBackground = Color(0xFFFAFAFA);
const Color kBuyNowColor = Color(0xFF38B000);
const String kLogoPath = "assets/images/mandauefoam_Logo1.png";
const String kARIconPath = "assets/images/ar_icon.png";

// --- UPDATED MOCK DATA WITH ASSET PATHS AND EXTERNAL URLS ---
const Map<String, dynamic> _mockHomeData = {
  "offers": [
    {"name": "Large table lamp Mallorca", "price": "150", "oldPrice": "205", "image": "coral_desk.png", "external_url": "https://mandauefoam.ph/products/coral-desk?_pos=1&_psq=coral&_ss=e&_v=1.0"},
    {"name": "Silas dispensers", "price": "20", "oldPrice": "28", "image": "georgine_3_chest_of_drawer_maple.png", "external_url": "https://mandauefoam.ph/products/georgine-chest-of-drawer-maple?_pos=2&_psq=georgina&_ss=e&_v=1.0"},
  ],
  "new_collections": [
    {"name": "Large Chest of Drawers", "price": "205", "description": "Define and tidy your room...", "image": "georgine_3_chest_of_drawer_maple.png", "external_url": "https://mandauefoam.ph/products/georgine-chest-of-drawer-maple?_pos=2&_psq=georgina&_ss=e&_v=1.0"},
    {"name": "Hamilton Sectional Sofa", "price": "821", "description":
    "Its straight and simple lines...", "image": "hamilton_sofa_bed_right_chaise_sofa.png", "external_url": "https://mandauefoam.ph/products/hamilton-sofa-bed-right-chaise-sofa?_pos=2&_psq=hamilton&_ss=e&_v=1.0"},
  ],
  "favorites": [
    {"name": "Coral Desk", "price": "2,750", "image": "coral_desk.png", "external_url": "https://mandauefoam.ph/products/coral-desk?_pos=1&_psq=coral&_ss=e&_v=1.0"},
    {"name": "Reese Display Cabinet", "price": "1,590", "image": "reese_high_display_cabinet_with_wheel.png", "external_url": "https://mandauefoam.ph/products/reese-high-display-cabinet-with-wheel?_pos=1&_psq=reese&_ss=e&_v=1.0"},
    {"name": "Tripp Cabinet", "price": "150", "image": "tripp_display_cabinet.png", "external_url": "https://mandauefoam.ph/products/tripp-high-display-cabinet?_pos=1&_psq=tripp&_ss=e&_v=1.0"},
  ]
};

// --- UTILITY FUNCTIONS ---
Future<void> _launchURL(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    _showSnackBar(context, 'Could not launch $url');
  }
}

void _showSnackBar(BuildContext ctx, String msg) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}

// --- MAIN FUNCTION ---
void main() {
  runApp(const MyApp());
}

// --- APP WIDGET ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      primaryColor: kPrimaryBlue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
          0xFF1F41BB,
          <int, Color>{
            50: Color(0xFFE4E7F4), 100: Color(0xFFBCC4E2), 200: Color(0xFF919CDE),
            300: Color(0xFF6774DA), 400: Color(0xFF4756D8), 500: kPrimaryBlue,
            600: Color(0xFF1B3ABB), 700: Color(0xFF1632B9), 800: Color(0xFF122BB6),
            900: Color(0xFF0A1EAF),
          },
        ),
      ).copyWith(secondary: kPrimaryBlue),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Poppins",
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: kLightFieldColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryBlue, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mandaue Foam AR",
      theme: _buildTheme(context),
      initialRoute: "/",
      routes: {
        "/": (context) => const AuthScreen(),
        "/home": (context) => const HomeWrapper(),
        "/tutorial": (context) => const TutorialScreen(),
        "/ar_actual": (context) => const ARViewScreen(),
      },
    );
  }
}

// --- REUSABLE PASSWORD TEXT FIELD WIDGET ---
class PasswordTextField extends StatefulWidget {
  final String hintText;
  const PasswordTextField({super.key, required this.hintText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isVisible,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _isVisible ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryBlue,
          ),
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
        ),
      ),
    );
  }
}


////////////////////////
/// AUTH SCREENS
////////////////////////

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();

  void _goToRegister() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _goToLogin() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _LoginScreen(
            onNavigateToRegister: _goToRegister,
            onNavigateToForgot: _goToForgotPassword,
          ),
          _RegisterScreen(onNavigateToLogin: _goToLogin),
        ],
      ),
    );
  }
}

// --- LOGIN ---
class _LoginScreen extends StatelessWidget {
  final VoidCallback onNavigateToRegister;
  final VoidCallback onNavigateToForgot;
  const _LoginScreen({required this.onNavigateToRegister, required this.onNavigateToForgot});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset(kLogoPath, height: 80),
          const SizedBox(height: 40),

          const Text(
            "Login here",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kPrimaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Welcome back you’ve been missed!",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),

          const TextField(
            decoration: InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 16),
          const PasswordTextField(hintText: "Password"),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onNavigateToForgot,
              child: const Text(
                "Forgot your password?",
                style: TextStyle(color: kPrimaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
              child: const Text("Sign in"),
            ),
          ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: onNavigateToRegister,
            child: const Text("Create new account",
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// --- REGISTER ---
class _RegisterScreen extends StatelessWidget {
  final VoidCallback onNavigateToLogin;
  const _RegisterScreen({required this.onNavigateToLogin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Image.asset(kLogoPath, height: 80),
          const SizedBox(height: 40),

          const Text(
            "Create Account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kPrimaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Create an account so you can explore all the existing products",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),

          const TextField(decoration: InputDecoration(hintText: "Email")),
          const SizedBox(height: 16),
          const PasswordTextField(hintText: "Password"),
          const SizedBox(height: 16),
          const PasswordTextField(hintText: "Confirm Password"),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
              child: const Text("Sign up"),
            ),
          ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: onNavigateToLogin,
            child: const Text("Already have an account",
                style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

// --- FORGOT PASSWORD ---
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      // AppBar handles the back button and Logo
      appBar: AppBar(
        title: Image.asset(kLogoPath, height: 32),
        centerTitle: true,
        backgroundColor: kLightBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryBlue), // Back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Forgot Password",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryBlue),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your email to receive a reset link.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            const TextField(decoration: InputDecoration(hintText: "Email")),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showSnackBar(context, "Pretend reset link sent 📧");
                  Navigator.pop(context);
                },
                child: const Text("Send Reset Link"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HOME SCREEN WRAPPER (Handles Bottom Navigation) ---
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});
  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;

  // The actual screens corresponding to the nav bar items
  final List<Widget> _screens = const [
    HomeScreen(),
    SavesScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Index 2 is the AR button, navigate to Tutorial screen
      Navigator.pushNamed(context, "/tutorial");
    } else {
      // Map nav bar index (0, 1, 3, 4) to screens index (0, 1, 2, 3)
      final screenIndex = index > 2 ? index - 1 : index;
      setState(() {
        _selectedIndex = screenIndex;
      });
    }
  }

  // FIX: AR Button is simplified and styled to match the image
  Widget _buildARButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _onItemTapped(2), // Navigates to Tutorial screen
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              kARIconPath,
              height: 28,
              width: 28,
              color: kPrimaryBlue,
            ),
          ),
          const Text('AR View', style: TextStyle(color: kPrimaryBlue, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, 'Home', 0, onTap: _onItemTapped),
          _buildNavBarItem(Icons.bookmark_border, 'Saves', 1, onTap: _onItemTapped),
          _buildARButton(context), // AR button (index 2)
          _buildNavBarItem(Icons.notifications_none, 'Alerts', 3, onTap: _onItemTapped),
          _buildNavBarItem(Icons.person_outline, 'Profile', 4, onTap: _onItemTapped),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, int index, {required Function(int) onTap}) {
    // Logic to correctly set color based on current index
    final screenIndex = index > 2 ? index - 1 : index;
    final isSelected = screenIndex == _selectedIndex && index != 2;
    final color = isSelected ? kPrimaryBlue : Colors.grey[600];

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          Text(label, style: TextStyle(color: color, fontSize: 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Drawer(child: MenuScreen()),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}

// --- HOME SCREEN CONTENT ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- START OF HELPER METHODS FOR HOME SCREEN ---

  // Helper widget to handle navigation from the App Bar Profile Icon
  Widget _buildProfileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Profile tab (index 4 in bottom navigation)
        (context.findAncestorStateOfType<_HomeWrapperState>())?._onItemTapped(4);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.person, color: kHeaderTextColor),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    // This context needs to be the one directly below the Scaffold (the Builder context)
    return SliverAppBar(
      backgroundColor: kCardBackground,
      pinned: true,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(kLogoPath, height: 32),
          Row(
            children: [
              _buildProfileIcon(context), // Profile Icon is now clickable
              IconButton(
                icon: const Icon(Icons.menu, color: kHeaderTextColor),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(String title, String fontFamily) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 32, bottom: 16),
        child: Text(
          title,
          style: TextStyle(
            color: kHeaderTextColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHorizontalList(List<Map<String, dynamic>> items, Widget Function(Map<String, dynamic>) cardBuilder) {
    return SliverToBoxAdapter(
      child: SizedBox(
        // Set height based on card complexity
        height: items.first.containsKey('description') ? 280 : 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: cardBuilder(items[index]),
          ),
        ),
      ),
    );
  }

  SliverGrid _buildFavoritesGrid(List<Map<String, dynamic>> items) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildFavoriteCard(context, items[index]);
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> item) {
    return Card(
      color: const Color(0xFFE4ECF3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.asset("assets/images/${item["image"]}", height: 80, width: 80, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("\$ ${item["price"]!}", style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryBlue)),
                      const SizedBox(width: 8),
                      Text(
                        "\$ ${item["oldPrice"]!}",
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryBlue,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('AR VIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> item) {
    return Card(
      color: const Color(0xFFCECAC5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Center(child: Image.asset("assets/images/${item["image"]}", fit: BoxFit.cover))),
            const SizedBox(height: 12),
            Text(item["name"]!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(item["description"]!, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                child: const Text('AR VIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> item) {
    // Tapping the card navigates to ProductDetailScreen
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item))),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/${item["image"]}", fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                item["name"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: kHeaderTextColor,
                  fontFamily: 'Roboto',
                ),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(
                  "\$ ${item["price"]!}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: kHeaderTextColor,
                    fontFamily: 'Roboto',
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
  // --- END OF HELPER METHODS FOR HOME SCREEN ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                _buildSectionHeader("Offers", "Roboto"),
                _buildHorizontalList(_mockHomeData["offers"]!, _buildOfferCard),
                _buildSectionHeader("New collections", "Roboto"),
                _buildHorizontalList(_mockHomeData["new_collections"]!, _buildCollectionCard),
                _buildSectionHeader("Favorites", "Roboto"),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: _buildFavoritesGrid(_mockHomeData["favorites"]!),
                ),
                const SliverToBoxAdapter(
                  // Final spacing to lift content above the fixed bottom bar
                  child: SizedBox(height: 100),
                ),
              ],
            );
          }
      ),
    );
  }
}

// --- SAVES SCREEN ---
class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Items"), backgroundColor: kCardBackground, elevation: 0),
      body: const Center(
        child: Text("Your saved furniture items will appear here.", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// --- ALERTS/NOTIFICATIONS SCREEN ---
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), backgroundColor: kCardBackground, elevation: 0),
      body: const Center(
        child: Text("Notifications and alerts will be listed here.", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

// --- PROFILE SCREEN ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("PROFILE"), // Title matching Figma
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button as it's a root tab
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: kHeaderTextColor),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false), // Logout
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- USER INFO SECTION ---
            Row(
              children: [
                // Profile Picture (Placeholder)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Bruno Pham", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("bruno203@gmail.com", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- SETTINGS MENU TILE (Clickable) ---
            Container(
              decoration: BoxDecoration(
                color: kLightBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  "Setting",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "Notification, Password, FAQ, Contact", // Subtitle listing the screens
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to the new settings menu screen
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsMenuScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- SETTINGS MENU SCREEN (New Screen) ---
class SettingsMenuScreen extends StatelessWidget {
  const SettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          _buildSettingsTile(context, "Notifications", Icons.notifications_none, target: AlertsScreen()),
          _buildSettingsTile(context, "Change Password", Icons.lock_outline, target: ForgotPasswordScreen()), // Reuse ForgotPassword for security action
          _buildSettingsTile(context, "FAQ & Help", Icons.help_outline, target: PlaceholderScreen(title: "FAQ & Help")),
          _buildSettingsTile(context, "Contact Us", Icons.support_agent, target: PlaceholderScreen(title: "Contact Us")),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {required Widget target}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: kPrimaryBlue),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => target));
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}

// --- PLACEHOLDER SCREEN (New Helper) ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("This is the $title Screen", style: const TextStyle(fontSize: 18, color: Colors.grey)),
      ),
    );
  }
}

// --- TUTORIAL SCREEN ---
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> tutorialPages = [
    {"title": "TUTORIAL PAGE 1", "subtitle": "Select your desired furniture"},
    {"title": "TUTORIAL PAGE 2", "subtitle": "Click AR button"},
    {"title": "TUTORIAL PAGE 3", "subtitle": "Expand to see more available furniture colors"},
    {"title": "TUTORIAL PAGE 4", "subtitle": "Rotate 3D furniture objects 360°"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: tutorialPages.length,
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
            },
            itemBuilder: (context, index) {
              final page = tutorialPages[index];
              return _buildTutorialPage(context, page, index);
            },
          ),

          // Navigation Dots
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                tutorialPages.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? kPrimaryBlue : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialPage(BuildContext context, Map<String, dynamic> page, int index) {
    final bool isLastPage = index == tutorialPages.length - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Close button (Top Right)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 30),
              onPressed: () => Navigator.pop(context), // Go back to Home
            ),
          ),
          const SizedBox(height: 20),

          Text(page['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Placeholder for the Tutorial Image
          Container(
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(page['subtitle']!, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 40),

          // Next/Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isLastPage) {
                  // Final page: Navigate to actual AR screen
                  Navigator.pushReplacementNamed(context, "/ar_actual");
                } else {
                  // Next page
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(isLastPage ? 'Start AR Experience' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

// --- AR VIEW (placeholder) ---
class ARViewScreen extends StatelessWidget {
  const ARViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Furniture Preview")),
      body: Stack(
        children: [
          Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Text("📱 [AR Camera Placeholder]", style: TextStyle(fontSize: 18)),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _showSnackBar(context, "Beige selected"), child: const Text("Beige")),
                ElevatedButton(onPressed: () => _showSnackBar(context, "Gray selected"), child: const Text("Gray")),
                ElevatedButton(onPressed: () => _showSnackBar(context, "Blue selected"), child: const Text("Blue")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- MENU SCREEN (Drawer Content) ---
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Drawer width
      color: kLightBackgroundColor,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // Logo placed at the top of the menu
          Image.asset(kLogoPath, height: 40),
          const SizedBox(height: 40),

          // About our application tile
          _buildMenuTile(context, "About our application", onPressed: () {
            // FIX: Navigate to the new AboutScreen
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutScreen()));
          }),

          // Tutorial how to use AR tile
          _buildMenuTile(context, "Tutorial how to use AR", onPressed: () {
            Navigator.pop(context); // Close Drawer
            Navigator.pushNamed(context, "/tutorial");
          }),

          // Note: Profile and Exit tiles are removed here to match your image design.
        ],
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, String title,
      {required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: kHeaderTextColor,
          ),
        ),
      ),
    );
  }
}

// --- ABOUT APPLICATION SCREEN (New Feature) ---
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // The descriptive text from your mockup
  static const String _aboutText =
      "Mandaue Foam AR application aims to enhance the shopping experience for Mandaue Foam customers by allowing them to visualize furniture in their own space using augmented reality. This helps customers make more informed decisions, ensuring that the size, style, and color of furniture items match their home before purchasing.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: Center(
        child: Container(
          width: 300, // Matching the general width of the menu card
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Icon
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // Logo
              Image.asset(kLogoPath, height: 40),
              const SizedBox(height: 20),

              // Title
              const Text(
                "About our application",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: kHeaderTextColor),
              ),
              const SizedBox(height: 10),

              // Description
              const Text(
                _aboutText,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- PRODUCT DETAIL SCREEN ---
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedColorIndex = 0;
  final List<Color> colors = [Colors.black, const Color(0xFFCECAC5), kPrimaryBlue];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]!),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/${product["image"]}",
                  fit: BoxFit.contain,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product["name"]!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text("4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            const Text("Armchair", style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            const Text(
              "Simple & elegant shape makes it very suitable for minimalist rooms... Read More",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // --- Colors & AR Button (Small Icon) ---
            Row(
              children: [
                // Color Selector Dots
                ...List.generate(colors.length, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colors[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColorIndex == index ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/tutorial"); // Go to tutorial screen
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(kARIconPath, height: 28, width: 28, color: kPrimaryBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Full Width Buttons ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/tutorial"); // Go to tutorial screen
                },
                child: const Text("View in AR Camera"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBuyNowColor, // Green for "Buy Now"
                ),
                onPressed: () {
                  final String externalUrl = widget.product["external_url"] ?? "https://mandauefoam.ph/products/default-page";
                  _launchURL(context, externalUrl);
                },
                child: const Text("Buy Now on Mandaue Foam Website"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}