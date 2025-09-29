import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  // 1. Ensure widgets are bound
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase using the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
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

void _showSnackBar(BuildContext ctx, String msg, {Color backgroundColor = Colors.red}) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: backgroundColor, // Set background color based on severity/type
      behavior: SnackBarBehavior.floating, // Helps visibility
      duration: const Duration(seconds: 3),
    ),
  );
}
// --- NEW GLOBAL GOOGLE SIGN-IN HANDLER ---
Future<void> _handleGoogleSignIn(BuildContext context) async {
  // Use a local loading state if needed, but for simplicity, we'll rely on the button's built-in state.

  try {
    // 1. Trigger the Google Authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // User cancelled the sign-in

    // 2. Obtain the auth details
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 3. Sign in/Up to Firebase with the Google credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Success: Navigate to home screen
    if (context.mounted) {
      _showSnackBar(context, "Signed in with Google!", backgroundColor: kBuyNowColor);
      Navigator.pushReplacementNamed(context, "/home");
    }

  } on FirebaseAuthException catch (e) {
    String message = "Google Sign-In failed. Please try again.";
    if (e.code == 'account-exists-with-different-credential') {
      message = "Account already exists with email. Use the password field.";
    }
    if (context.mounted) _showSnackBar(context, message);

  } catch (e) {
    // Catches the fatal runtime error (Pigeon crash) gracefully.
    if (context.mounted) _showSnackBar(context, "An unexpected error occurred. Please try again.", backgroundColor: Colors.orange);
  }
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
// --- REUSABLE PASSWORD TEXT FIELD WIDGET ---
class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller; // ADDED Controller parameter
  const PasswordTextField({super.key, required this.hintText, this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Use the provided controller
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

// --- LOGIN SCREEN ---
class _LoginScreen extends StatefulWidget {
  final VoidCallback onNavigateToRegister;
  final VoidCallback onNavigateToForgot;
  const _LoginScreen({required this.onNavigateToRegister, required this.onNavigateToForgot});

  @override
  State<_LoginScreen> createState() => __LoginScreenState();
}


// --- LOGIN SCREEN STATE (Firebase Enabled) ---
class __LoginScreenState extends State<_LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- EMAIL/PASSWORD SIGN-IN FUNCTION (Unchanged) ---
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        _showSnackBar(
            context, "Sign in successful!", backgroundColor: kBuyNowColor);
        Navigator.pushReplacementNamed(context, "/home");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "user-not-found":
        case "wrong-password":
        case "invalid-credential":
          errorMessage =
          "Invalid email or password. Please check your credentials.";
          break;
        case "invalid-email":
          errorMessage = "The email address format is invalid.";
          break;
        default:
          errorMessage = "Login failed: ${e.message}";
      }
      if (mounted) _showSnackBar(context, errorMessage);
    } catch (e) {
      if (mounted) _showSnackBar(
          context, "An unexpected error occurred. Please try again.",
          backgroundColor: Colors.orange);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// Inside the __LoginScreenState class:
  @override
  Widget build(BuildContext context) {
    // ... (UI elements omitted for brevity)
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

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            hintText: "Password",
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onNavigateToForgot,
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
              onPressed: _isLoading ? null : _signIn,
              child: _isLoading
                  ? const SizedBox(width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
                  : const Text("Sign in"),
            ),
          ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: widget.onNavigateToRegister,
            child: const Text("Create new account",
                style: TextStyle(color: Colors.grey)),
          ),

          // --- GOOGLE SIGN-IN UI ---
          const SizedBox(height: 20),
          const Text("Or continue with", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),

          GestureDetector( // Use GestureDetector to keep the click action
            onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
            child: Material(
              elevation: 2, // Gives a slight elevation matching the primary button
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Apply the desired corner radius
              child: InkWell( // Use InkWell for splash effect inside Material
                borderRadius: BorderRadius.circular(12),
                onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment: Alignment.center,
                  // FIX: Use the image asset directly. The image already contains the text and logo.
                  child: Image.asset(
                    'assets/images/Sign_in_with_google.png', // Or 'Sign_up_with_google.png'
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
// --- END OF GOOGLE SIGN-IN UI ---
        ],
      ),
    );
  }
}

// --- REGISTER ---
// --- REGISTER SCREEN ---
class _RegisterScreen extends StatefulWidget {
  final VoidCallback onNavigateToLogin;
  const _RegisterScreen({required this.onNavigateToLogin});

  @override
  State<_RegisterScreen> createState() => __RegisterScreenState();
}

// --- REGISTER SCREEN STATE (Firebase Enabled) ---
class __RegisterScreenState extends State<_RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      _showSnackBar(context, "Passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Success: Navigate to home screen
      if (mounted) Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      String message = "Sign up failed.";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      if (mounted) _showSnackBar(context, message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Inside the __RegisterScreenState class:
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

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            hintText: "Password",
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp, // Disable if loading
              child: _isLoading
                  ? const SizedBox(width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3))
                  : const Text("Sign up"),
            ),
          ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: widget.onNavigateToLogin,
            child: const Text("Already have an account",
                style: TextStyle(color: Colors.grey)),
          ),

// --- GOOGLE SIGN-IN UI ---
          const SizedBox(height: 20),
          const Text("Or continue with", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
            child: Material(
              elevation: 2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _isLoading ? null : () => _handleGoogleSignIn(context),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  // FIX: Reduced vertical padding to give the image more space and prevent clipping.
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  alignment: Alignment.center,
                  child: Image.asset(
                    // Correct Asset Path
                    'assets/images/Sign_in_with_google.png',
                    // FIX: Ensure the height is slightly less than the container (50) to prevent overflow
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // --- END OF GOOGLE SIGN-IN UI ---
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
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              kARIconPath,
              height: 60,
              width: 60,

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
            color: Colors.black.withValues(alpha: 0.1),
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

  Widget _buildProfileIcon(BuildContext context) {
    // Helper to find the parent HomeWrapper state and switch tabs
    return GestureDetector(
      onTap: () {
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
    return SliverAppBar(
      backgroundColor: kCardBackground,
      pinned: true,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(kLogoPath, height: 32),
          Builder( // Add a Builder ONLY around the Row with the icons
            builder: (innerContext) => Row(
              children: [
                _buildProfileIcon(innerContext),
                IconButton(
                  icon: const Icon(Icons.menu, color: kHeaderTextColor),
                  onPressed: () => Scaffold.of(innerContext).openEndDrawer(), // Use the innerContext
                ),
              ],
            ),
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
// --- SAVES SCREEN (Rebuilt to match Figma Favorite List) ---
class SavesScreen extends StatelessWidget {
  const SavesScreen({super.key});

  // Mock list of saved items based on the provided design
  final List<Map<String, dynamic>> _savedItems = const [
    {"name": "Coffee Table", "price": "50.00", "image": "coral_desk.png"},
    {"name": "Coffee Chair", "price": "20.00", "image": "georgine_3_chest_of_drawer_maple.png"},
    {"name": "Minimal Stand", "price": "25.00", "image": "reese_high_display_cabinet_with_wheel.png"},
    {"name": "Minimal Desk", "price": "50.00", "image": "hamilton_sofa_bed_right_chaise_sofa.png"},
    {"name": "Minimal Lamp", "price": "12.00", "image": "tripp_display_cabinet.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents an extra back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.search, color: Colors.black, size: 28),
            const Text("FAVORITE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            // Replaced the cart icon with a generic icon since we removed cart functionality
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
              onPressed: () => _showSnackBar(context, "Cart functionality is disabled."),
            ),
          ],
        ),
      ),

      // Use ListView to build the scrolling list of saved items
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: _savedItems.length,
        itemBuilder: (context, index) {
          return _buildFavoriteTile(context, _savedItems[index]);
        },
      ),
    );
  }

  Widget _buildFavoriteTile(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Product Image ---
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: kCardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/${item["image"]}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey)),
              ),
            ),
          ),

          // --- Title and Price ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item["name"]!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$ ${item["price"]!}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),

          // --- Remove Icon (X) ---
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () => _showSnackBar(context, "Removed ${item["name"]}", backgroundColor: Colors.orange),
          ),

          // --- Action Button (Replaced Small Cart with Buy Now Intent) ---
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.open_in_new, size: 20, color: Colors.white),
              onPressed: () {
                // Since this screen doesn't have the external_url data, we mock it:
                final mockSlug = item["name"]!.toLowerCase().replaceAll(' ', '-');
                _launchURL(context, "https://mandauefoam.ph/products/$mockSlug");
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- ALERTS/NOTIFICATIONS SCREEN (Rebuilt to match Figma Notification List) ---
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  // Mock list of notifications mirroring the types in the Figma design
  final List<Map<String, dynamic>> _mockNotifications = const [
    {"type": "order_confirmed", "title": "Your order #123456789 has been confirmed", "status": "New", "image": "coral_desk.png"},
    {"type": "order_canceled", "title": "Your order #123456789 has been canceled", "status": null, "image": "georgine_3_chest_of_drawer_maple.png"},
    {"type": "promo_header", "title": "Discover hot sale furniture's this week.", "subtitle": "Turps premium et in arc adipiscing nec.", "status": "HOT!"},
    {"type": "order_shipped", "title": "Your order #123456789 has been shipped successfully", "subtitle": "Please help us to confirm and rate your order to get 10% discount code for next order.", "image": "hamilton_sofa_bed_right_chaise_sofa.png"},
    {"type": "order_confirmed", "title": "Your order #123456789 has been confirmed", "status": null, "image": "reese_high_display_cabinet_with_wheel.png"},
    {"type": "order_canceled", "title": "Your order #123456789 has been canceled", "status": null, "image": "tripp_display_cabinet.png"},
    {"type": "order_shipped", "title": "Your order #123456789 has been shipped successfully", "subtitle": "Please help us to confirm and rate your order to get 10% discount code for next order.", "image": "coral_desk.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 24, // Add spacing to align with the rest of the padding
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _mockNotifications.length,
        itemBuilder: (context, index) {
          final item = _mockNotifications[index];

          if (item["type"] == "promo_header") {
            return _buildPromoHeader(item);
          }
          return _buildNotificationTile(item);
        },
      ),
    );
  }

  Widget _buildPromoHeader(Map<String, dynamic> item) {
    // Large promotional tile
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["title"]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            item["subtitle"]!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (item["status"] == "HOT!")
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text("HOT!", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> item) {
    final bool isConfirmed = item["type"] == "order_confirmed" || item["type"] == "order_shipped";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Thumbnail ---
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/${item["image"]}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 20, color: Colors.grey)),
              ),
            ),
          ),

          // --- Text Content ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Main Title (Confirmed/Canceled/Shipped)
                    Expanded(
                      child: Text(
                        item["title"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isConfirmed ? Colors.green[700] : Colors.red[700],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // "New" Status Badge
                    if (item["status"] == "New")
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("New", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Subtitle/Description
                Text(
                  item["subtitle"] ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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
                    Text("Bruno Pharma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
// --- SETTINGS MENU SCREEN (Finalized) ---
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
          // Notifications -> Go to the AlertsScreen (which is the actual notification list)
          _buildSettingsTile(
            context,
            "Notifications",
            Icons.notifications_none,
            target: const AlertsScreen(),
          ),
          // Change Password -> Dedicated local screen
          _buildSettingsTile(
            context,
            "Change Password",
            Icons.lock_outline,
            target: const ChangePasswordScreen(),
          ),
          // FAQ & Help -> Display text and links from the Mandauefoam help center
          _buildSettingsTile(
            context,
            "FAQ & Help",
            Icons.help_outline,
            target: const HelpAndFAQScreen(),
          ),
          // Contact Us -> Display contact information and form link
          _buildSettingsTile(
            context,
            "Contact Us",
            Icons.support_agent,
            target: const ContactUsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon,
      {required Widget target}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: kPrimaryBlue),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => target));
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}
// --- REUSABLE WEBVIEW SCREEN ---
class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchURL(context, url),
          child: const Text("Open in Browser"),
        ),
      ),
    );
  }
}


// --- CHANGE PASSWORD SCREEN (New Feature) ---
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Update Your Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Input fields for password change logic
            const PasswordTextField(hintText: "Current Password"),
            const SizedBox(height: 16),
            const PasswordTextField(hintText: "New Password"),
            const SizedBox(height: 16),
            const PasswordTextField(hintText: "Confirm New Password"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSnackBar(context, "Password change functionality mocked."),
                child: const Text("Save New Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- FAQ & HELP SCREEN (Text Content) ---
class HelpAndFAQScreen extends StatelessWidget {
  const HelpAndFAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // URL from the help-center text snippet
    const String faqUrl = "https://mandauefoam.ph/pages/help-center";

    return Scaffold(
      appBar: AppBar(title: const Text("FAQ & Help")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Frequently Asked Questions (FAQs)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Check out our Frequently Asked Questions (FAQs) through this link:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _launchURL(context, faqUrl),
              child: const Text(faqUrl, style: TextStyle(color: kPrimaryBlue)),
            ),
            const SizedBox(height: 30),
            const Text("Need More Help?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "For further assistance, please use the Contact Us page or reach out via our Customer Support channels.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// --- CONTACT US SCREEN (Support Information) ---
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data from the Facebook Messenger snippet
    const String hotline = "(02) 8-424-3000";
    const String chatHours = "9am to 6pm";

    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Customer Support", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // --- Hotline ---
            const Text("Customer Hotline (Luzon):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(hotline, style: const TextStyle(fontSize: 16, color: kPrimaryBlue)),
            TextButton(
              onPressed: () => _launchURL(context, "tel:$hotline"),
              child: const Text("Tap to Call"),
            ),
            const SizedBox(height: 15),

            // --- Availability ---
            const Text("Available Hours:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(chatHours, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const Text("We are available daily at 10am to 6pm for your inquiries and other concerns."),
            const SizedBox(height: 30),

            // --- Digital Chat / Form Link ---
            const Text("Online Contact Form", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text("Open Inquiry Form"),
              onPressed: () {
                // Link to the form shown in the provided image (mocking the submission page)
                _launchURL(context, "https://mandauefoam.ph/pages/contact-us");
              },
            ),
          ],
        ),
      ),
    );
  }
}


// --- PLACEHOLDER SCREEN ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("This is the $title screen",
            style: const TextStyle(fontSize: 18, color: Colors.grey)),
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