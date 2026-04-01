import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await FirebaseAuth.instance.signOut();
      final userBox = Hive.box('favorites');
      await userBox.delete('user_session');

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName?.isNotEmpty == true
                              ? user!.displayName!
                              : 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Section Label ─────────────────────────────────────────
            Text(
              'Account',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            // ── Settings Tiles ────────────────────────────────────────
            _SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: Colors.orange,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.lock_rounded,
              iconColor: Colors.purple,
              title: 'Privacy',
              subtitle: 'Control your privacy settings',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.language_rounded,
              iconColor: Colors.teal,
              title: 'Language',
              subtitle: 'Change app language',
              onTap: () {},
            ),

            const SizedBox(height: 28),

            Text(
              'Support',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            _SettingsTile(
              icon: Icons.help_outline_rounded,
              iconColor: Colors.blue,
              title: 'Help & Support',
              subtitle: 'Get help or contact us',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: Colors.blueGrey,
              title: 'About',
              subtitle: 'App version & info',
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // ── Logout Button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: Colors.redAccent.withOpacity(0.4),
                ),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey.shade400,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
