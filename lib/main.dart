import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// --- CONSTANTS ---
// Colors based on Figma:
const Color kPrimaryBlue = Color(0xFF1F41BB);
const Color kHeaderTextColor = Color(0xFF666666);
const Color kLightFieldColor = Color(0xFFF1F4FF);
const Color kLightBackgroundColor = Color(0xFFF9FAFD); // Auth screen background
const Color kCardBackground = Color(0xFFFAFAFA); // Home screen background
const Color kDisabledColor = Color(0xFF896BFF); // Purple color from add to cart button

// Placeholder data structure to match the complex Figma layout
const Map<String, dynamic> _mockHomeData = {
  "offers": [
    {"name": "Large table lamp Mallorca", "price": "150", "oldPrice": "205", "image": "coral_desk.png"},
    {"name": "Silas dispensers", "price": "20", "oldPrice": "28", "image":
    "georgine_3_chest_of_drawer_maple.png"},
  ],
  "new_collections": [
    {"name": "Large table lamp Mallorca", "price": "205", "description": "Define and tidy your room in one fell swoop with this distinctive dressing table. Part of our Dayton collection, it is designed for small spaces, but can work anywhere you need storage.", "image": "georgine_3_chest_of_drawer_maple.png"},
    {"name": "Lindwood Nightstand", "price": "821", "description":
    "Its straight and simple lines give our Linwood collection an attractive and direct style. With its off-white finish and antique hardware details, this bureau offers contrast and a vintage touch.", "image": "hamilton_sofa_bed_right_chaise_sofa.png"},
  ],
  "favorites": [
    {"name": "Oakleigh king size bed", "price": "2,750", "image": "coral_desk.png"},
    {"name": "Studded armchair Irving", "price": "1,590", "image": "tripp_display_cabinet.png"},
    {"name": "Balboa armchair single", "price": "150", "image": "georgine_3_chest_of_drawer_maple.png"},
  ]
};

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
      fontFamily: "Poppins", // Recommended from Figma
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: kLightFieldColor, // Light blue background for fields
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
        "/home": (context) => const HomeScreen(),
        // Define other screens that might be navigated to via named routes, even if AuthScreen handles them internally
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _LoginScreen(onNavigateToRegister: _goToRegister),
          _RegisterScreen(onNavigateToLogin: _goToLogin),
          const _ForgotPasswordScreen(), // keep forgot inside pager if you want
        ],
      ),
    );
  }
}

////////////////////////
/// LOGIN
////////////////////////
class _LoginScreen extends StatelessWidget {
  final VoidCallback onNavigateToRegister;
  const _LoginScreen({required this.onNavigateToRegister});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Logo
          Image.asset("assets/images/mandauefoam_Logo1.png", height: 80),
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
          const TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: "Password"),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const _ForgotPasswordScreen()),
                );
              },
              child: const Text(
                "Forgot your password?",
                style: TextStyle(color: kPrimaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Button
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

////////////////////////
/// REGISTER
////////////////////////
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
          Image.asset("assets/images/mandauefoam_Logo1.png", height: 80),
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
          const TextField(
              obscureText: true, decoration: InputDecoration(hintText: "Password")),
          const SizedBox(height: 16),
          const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: "Confirm Password")),
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

////////////////////////
/// FORGOT PASSWORD
////////////////////////
class _ForgotPasswordScreen extends StatelessWidget {
  const _ForgotPasswordScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/mandauefoam_Logo1.png", height: 80),
            const SizedBox(height: 40),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Pretend reset link sent 📧")));
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


// --- HOME SCREEN (Refactored to Figma design) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: We use a StatelessWidget and define mock data here for a clean single-file example
    // In a real app, product loading logic (like in the old HomeScreenState) should be kept.
    // For this demonstration, we focus purely on the Figma layout.

    return Scaffold(
      backgroundColor: kCardBackground, // Light grey background
      // --- Scrolling Body with Sliver App Bar ---
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),

          // --- Offers Section ---
          _buildSectionHeader("Offers", "Roboto"), // Font family 'Roboto'
          _buildHorizontalList(_mockHomeData["offers"]!, _buildOfferCard),

          // --- New Collections Section ---
          _buildSectionHeader("New collections", "Roboto"), // Font family 'Roboto'
          _buildHorizontalList(_mockHomeData["new_collections"]!, _buildCollectionCard),

          // --- Favorites Section ---
          _buildSectionHeader("Favorites", "Roboto"), // Font family 'Roboto'
          _buildFavoritesGrid(_mockHomeData["favorites"]!),

          const SliverToBoxAdapter(child: SizedBox(height: 100)), // Space for bottom bar
        ],
      ),
      // --- Custom Bottom Navigation Bar ---
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: kCardBackground,
      pinned: true,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Logo
          Image.asset("assets/images/mandauefoam_Logo1.png", height: 32), // Logo at the top

          // Right side: Cart and Profile picture
          Row(
            children: [
              // Cart icon with count
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: kHeaderTextColor),
                    onPressed: () {},
                  ),
                  const Positioned(
                    right: 4,
                    top: 4,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: kPrimaryBlue,
                      child: Text('4', style: TextStyle(color: Colors.white, fontSize: 10)), // Mock count
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Profile Picture (Placeholder)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.person, color: kHeaderTextColor),
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
            color: kHeaderTextColor, //
            fontSize: 24, // Adjusted from Figma 40 to fit mobile header size
            fontWeight: FontWeight.w500, //
            fontFamily: fontFamily,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHorizontalList(List<Map<String, dynamic>> items, Widget Function(Map<String, dynamic>) cardBuilder) {
    // Height is determined by the tallest card in this list
    return SliverToBoxAdapter(
      child: SizedBox(
        height: items.first.containsKey('description') ? 400 : 220,
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
        crossAxisCount: 3, // Changed to 3 items per row to fit the Figma layout
        childAspectRatio: 0.7, // Adjust ratio for better fit
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

  // --- CARD BUILDERS ---

  Widget _buildOfferCard(Map<String, dynamic> item) {
    // Card for the Offers section
    return Card(
      color: const Color(0xFFE4ECF3), // Light blue background
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image (Placeholder)
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
                            backgroundColor: kDisabledColor, // Purple/Disabled button look
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('ADD TO CART', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)), //
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
    // Card for New Collections section
    return Card(
      color: const Color(0xFFCECAC5), // Example background color
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(child: Center(child: Image.asset("assets/images/georgine_3_chest_of_drawer_maple.png", fit: BoxFit.cover))),
            const SizedBox(height: 12),
            Text(item["name"]!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), //
            Text(item["description"]!, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$ ${item["price"]!}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDisabledColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  child: const Text('ADD TO CART', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> item) {
    // Card for Favorites grid
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item))),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/coral_desk.png", fit: BoxFit.contain),
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
                    fontFamily: 'Roboto', //
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    // Custom Bottom Navigation Bar based on Figma
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
          _buildNavBarItem(Icons.home, 'Home', isSelected: true, onTap: () {}),
          _buildNavBarItem(Icons.bookmark_border, 'Saves', onTap: () {}),
          _buildARButton(context), // AR button
          _buildNavBarItem(Icons.notifications_none, 'Alerts', onTap: () {}),
          _buildNavBarItem(Icons.person_outline, 'Profile', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, {bool isSelected = false, required VoidCallback onTap}) {
    final color = isSelected ? kPrimaryBlue : Colors.grey[600];
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildARButton(BuildContext context) {
    // The prominent AR button in the bottom bar
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/ar"),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: kPrimaryBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: kPrimaryBlue.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Used a generic Material Icon since the custom Vector icon is complex to implement without SVG support
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
      ),
    );
  }
}

// --- ALL OTHER SCREENS (Kept for completeness) ---

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Pretend verification email sent ✅\nTap below once you’re ready.", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text("Resend Email"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pretend email re-sent 📧")));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text("I Verified, Continue"),
              onPressed: () => Navigator.pushReplacementNamed(context, "/home"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  // Use the defined constant blue color
  static const Color kPrimaryBlue = Color(0xFF1F41BB);
  static const Color kHeaderTextColor = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Updated Scaffold and App Bar for clean look
      appBar: AppBar(
        title: Text(product["name"]!),
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryBlue,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product Image
          Image.asset("assets/images/coral_desk.png", height: 200, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(product["name"]!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("₱${product["price"]!}", style: const TextStyle(fontSize: 18, color: kHeaderTextColor)),
          const SizedBox(height: 20),
          // View in AR Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/ar"),
              child: const Text("View in AR"),
            ),
          ),
        ],
      ),
    );
  }
}

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
                ElevatedButton(onPressed: () => _msg(context, "Beige"), child: const Text("Beige")),
                ElevatedButton(onPressed: () => _msg(context, "Gray"), child: const Text("Gray")),
                ElevatedButton(onPressed: () => _msg(context, "Blue"), child: const Text("Blue")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _msg(BuildContext ctx, String color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text("Pretend changed color to $color 🎨")),
    );
  }
}