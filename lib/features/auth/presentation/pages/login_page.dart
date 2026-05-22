import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthProvider>().signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - Reliable standard image loading for Web
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1542362567-b055002b9134?q=80&w=1200',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: Colors.black);
              },
            ),
          ),
          // Deep Luxury Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    Colors.black.withAlpha(102),
                    Colors.transparent,
                    Colors.black.withAlpha(204),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 70, color: Color(0xFFD4AF37)),
                    const SizedBox(height: 32),
                    Text(
                      'ELITE FLEET',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        letterSpacing: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'UNCOMPROMISING LUXURY',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 8,
                        color: Colors.white54,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 100),
                    _buildEliteTextField(
                      controller: _emailController,
                      label: 'CREDENTIAL EMAIL',
                      icon: Icons.alternate_email_rounded,
                    ),
                    const SizedBox(height: 32),
                    _buildEliteTextField(
                      controller: _passwordController,
                      label: 'SECURE ACCESS',
                      icon: Icons.lock_open_rounded,
                      isPassword: true,
                    ),
                    const SizedBox(height: 72),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
                            )
                          : const Text(
                              'IDENTIFY',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4),
                            ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: 'NEW TO THE CLUB? ', style: TextStyle(color: Colors.white30, letterSpacing: 1.5, fontSize: 11)),
                              TextSpan(
                                text: 'APPLY NOW',
                                style: TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: Color(0xFFD4AF37),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 1.5),
          cursorColor: const Color(0xFFD4AF37),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 22, color: Colors.white24),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
            ),
          ),
          validator: (value) => value!.isEmpty ? 'Field required' : null,
        ),
      ],
    );
  }
}
