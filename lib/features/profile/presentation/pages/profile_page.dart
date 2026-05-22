import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../admin/presentation/pages/admin_dashboard.dart';
import '../../../core/theme/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context, auth, isDark),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 120),
              child: Column(
                children: [
                  _ProfileSection(
                    title: 'PREFERENCES',
                    items: [
                      _ProfileItem(icon: Icons.person_outline_rounded, title: 'Personal Portfolio', onTap: () {}),
                      _ProfileItem(icon: Icons.history_rounded, title: 'Journey History', onTap: () {}),
                      _ProfileItem(icon: Icons.account_balance_wallet_outlined, title: 'Wallet & Payments', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _ProfileSection(
                    title: 'EXPERIENCE SETTINGS',
                    items: [
                      _ProfileItem(
                        icon: themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        title: 'Dark Mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(value),
                          activeColor: const Color(0xFFD4AF37),
                        ),
                      ),
                      _ProfileItem(icon: Icons.notifications_none_rounded, title: 'Notifications', onTap: () {}),
                      _ProfileItem(icon: Icons.shield_outlined, title: 'Security & Privacy', onTap: () {}),
                      if (auth.user?.email == 'admin@elite.com' || auth.isAuth)
                        _ProfileItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: 'Executive Dashboard',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminDashboard()),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _ProfileSection(
                    title: 'CONCIERGE',
                    items: [
                      _ProfileItem(icon: Icons.support_agent_rounded, title: 'Contact Concierge', onTap: () {}),
                      _ProfileItem(icon: Icons.info_outline_rounded, title: 'Terms of Excellence', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 64),
                  TextButton(
                    onPressed: () => auth.signOut(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    child: const Text('END SESSION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider auth, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 100, 32, 60),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFF1C1C1E),
                  child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            auth.user?.email?.split('@')[0].toUpperCase() ?? 'EXECUTIVE GUEST',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            auth.user?.email ?? 'experience@elitefleet.com',
            style: const TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _StatItem(label: 'Journeys', value: '12'),
                const _StatDivider(),
                const _StatItem(label: 'Reviews', value: '08'),
                const _StatDivider(),
                const _StatItem(label: 'Elite Points', value: '4.8k'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 3, color: Colors.black26),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(28),
            boxShadow: Theme.of(context).brightness == Brightness.light ? [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ] : null,
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ProfileItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withAlpha(12) : const Color(0xFFFBFBFD),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white24 : Colors.black12),
      onTap: onTap,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
