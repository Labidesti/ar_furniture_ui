import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

// --- APP WIDGET ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define the common theme styles based on your Figma colors (Blue: 0xFF1F41BB)
  ThemeData _buildTheme(BuildContext context) {
    const Color primaryBlue = Color(0xFF1F41BB);
    return ThemeData(
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
          0xFF1F41BB,
          <int, Color>{
            50: Color(0xFFE4E7F4),
            100: Color(0xFFBCC4E2),
            200: Color(0xFF919CDE),
            300: Color(0xFF6774DA),
            400: Color(0xFF4756D8),
            500: primaryBlue,
            600: Color(0xFF1B3ABB),
            700: Color(0xFF1632B9),
            800: Color(0xFF122BB6),
            900: Color(0xFF0A1EAF),
          },
        ),
      ).copyWith(secondary: primaryBlue),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Poppins", // Recommended from Figma
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF1F4FF), // Light blue background for fields
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
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
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
      // Define all routes to keep them functional
      initialRoute: "/",
      routes: {
        "/": (context) => const AuthScreen(), // Start with AuthScreen
        // Note: '/signup', '/forgot', etc. are now navigated to via MaterialPageRoute for simplicity in a single file
        "/home": (context) => const HomeScreen(),
        "/ar": (context) => const ARViewScreen(),
      },
    );
  }
}

// --- AUTH SCREEN (Combined Login/Register) ---
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();

  void _navigateToRegister() {
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _navigateToLogin() {
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Prevent accidental swipes
        children: [
          _LoginScreen(onNavigateToRegister: _navigateToRegister),
          _RegisterScreen(onNavigateToLogin: _navigateToLogin),
        ],
      ),
    );
  }
}


// --- LOGIN SCREEN WIDGET (Moved into file) ---
class _LoginScreen extends StatelessWidget {
  final VoidCallback onNavigateToRegister;
  const _LoginScreen({required this.onNavigateToRegister});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          // --- LOGO: mandauefoam_Logo.png ---
          Image.asset(
            "assets/images/mandauefoam_Logo.png", // Corrected logo path
            height: 80,
          ),
          const SizedBox(height: 30),
          // --- TITLE ---
          const Text(
            "Login here", //
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F41BB),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Welcome back you’ve been missed!",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),

          // --- FIELDS ---
          const TextField(decoration: InputDecoration(hintText: "Email")),
          const SizedBox(height: 16),
          const TextField(obscureText: true, decoration: InputDecoration(hintText: "Password")),

          const SizedBox(height: 10),
          // --- FORGOT PASSWORD ---
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
              child: const Text("Forgot your password?", style: TextStyle(color: Color(0xFF1F41BB))),
            ),
          ),

          const SizedBox(height: 20),
          // --- SIGN IN BUTTON ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pretend login success ✅")));
                Navigator.pushReplacementNamed(context, "/home");
              },
              child: const Text("Sign in"),
            ),
          ),

          const SizedBox(height: 20),
          // --- CREATE NEW ACCOUNT ---
          TextButton(
            onPressed: onNavigateToRegister,
            child: const Text("Create new account", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// --- REGISTER SCREEN WIDGET (Moved into file) ---
class _RegisterScreen extends StatelessWidget {
  final VoidCallback onNavigateToLogin;
  const _RegisterScreen({required this.onNavigateToLogin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          // --- LOGO: mandauefoam_Logo.png ---
          Image.asset(
            "assets/images/mandauefoam_Logo.png", // Corrected logo path
            height: 80,
          ),
          const SizedBox(height: 30),
          // --- TITLE ---
          const Text(
            "Create Account", //
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F41BB),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Create an account so you can explore all the existing jobs", //
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),

          // --- FIELDS ---
          const TextField(decoration: InputDecoration(hintText: "Email")),
          const SizedBox(height: 16),
          const TextField(obscureText: true, decoration: InputDecoration(hintText: "Password")),
          const SizedBox(height: 16),
          const TextField(obscureText: true, decoration: InputDecoration(hintText: "Confirm Password")),

          const SizedBox(height: 20),
          // --- SIGN UP BUTTON ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pretend signup success ✅")));
                Navigator.pushReplacementNamed(context, "/home"); // Navigate directly to home after signup
              },
              child: const Text("Sign up"),
            ),
          ),

          const SizedBox(height: 20),
          // --- ALREADY HAVE ACCOUNT ---
          TextButton(
            onPressed: onNavigateToLogin,
            child: const Text("Already have an account", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// --- ALL OTHER SCREENS (Unchanged Logic, Simplified Class Definitions) ---

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your email to receive a reset link."),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(hintText: "Email")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pretend reset link sent 📧")));
                Navigator.pop(context);
              },
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Note: Assuming assets/data/products.json exists and is structured correctly
    final String response = await rootBundle.loadString('assets/data/products.json');
    final data = json.decode(response);
    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Furniture Catalog")),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
            ),
            child: Card(
              child: Column(
                children: [
                  Expanded(child: Image.asset("assets/images/${p["image"]}", fit: BoxFit.cover)),
                  Text(p["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("₱${p["price"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product["name"])),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset("assets/images/${product["image"]}", height: 200, fit: BoxFit.cover),
          const SizedBox(height: 12),
          Text(product["name"], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("₱${product["price"]}", style: const TextStyle(fontSize: 18, color: Colors.green)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, "/ar"),
            child: const Text("View in AR"),
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