import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await context.read<AuthProvider>().signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Membership denied: ${e.toString()}'),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=2032&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.8, 1.0],
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(Icons.auto_awesome_rounded, size: 70, color: Color(0xFFD4AF37)),
                      const SizedBox(height: 32),
                      Text(
                        'MEMBERSHIP',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 40,
                          letterSpacing: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'JOIN THE ELITE CIRCLE',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 4,
                          color: Colors.white54,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      _buildEliteTextField(
                        controller: _nameController,
                        label: 'FULL NAME',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 32),
                      _buildEliteTextField(
                        controller: _emailController,
                        label: 'EMAIL ADDRESS',
                        icon: Icons.alternate_email_rounded,
                      ),
                      const SizedBox(height: 32),
                      _buildEliteTextField(
                        controller: _passwordController,
                        label: 'SECURITY KEY',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 72),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signup,
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
                                'REGISTER',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 4),
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
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
          validator: (value) => value!.isEmpty ? 'Required field' : null,
        ),
      ],
    );
  }
}
