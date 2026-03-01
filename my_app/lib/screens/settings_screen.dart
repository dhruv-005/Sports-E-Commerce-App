import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_style.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _initialized = false;
  bool _profileSaving = false;
  bool _contactSaving = false;

  static const _currencies = ['INR', 'USD', 'EUR', 'GBP'];
  static const _languages = ['English', 'Hindi', 'Spanish', 'French'];
  static const _sports = ['Football', 'Cricket', 'Basketball', 'Badminton'];

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final settings = context.read<AppSettingsProvider>();
    if (settings.isLoading) {
      await settings.loadSettings();
    }
    final name = await AuthService.registeredName();
    final email = await AuthService.registeredEmail();

    if (!mounted) return;

    _nameController.text = name ?? '';
    _emailController.text = email ?? '';
    _phoneController.text = settings.phone;
    _addressController.text = settings.address;
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() => _profileSaving = true);

    try {
      await AuthService.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _profileSaving = false);
      _showMessage('Could not update profile.');
      return;
    }

    if (!mounted) return;

    setState(() => _profileSaving = false);
    _showMessage('Profile updated.');
  }

  Future<void> _saveContact() async {
    if (!_contactFormKey.currentState!.validate()) return;

    setState(() => _contactSaving = true);

    try {
      await context.read<AppSettingsProvider>().updateContactInfo(
            phone: _phoneController.text,
            address: _addressController.text,
          );
    } catch (_) {
      if (!mounted) return;
      setState(() => _contactSaving = false);
      _showMessage('Could not save contact details.');
      return;
    }

    if (!mounted) return;

    setState(() => _contactSaving = false);
    _showMessage('Contact details saved.');
  }

  Future<void> _showPasswordDialog() async {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New password'),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Minimum 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm password'),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  await AuthService.updatePassword(passwordController.text);
                } catch (_) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Could not change password.')),
                  );
                  return;
                }
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                _showMessage('Password changed.');
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    passwordController.dispose();
    confirmController.dispose();
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _factoryReset() async {
    final cartProvider = context.read<CartProvider>();
    final settingsProvider = context.read<AppSettingsProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    final orderProvider = context.read<OrderProvider>();

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Factory Reset App?'),
            content: const Text(
              'This removes account, login state, cart, wishlist, orders, and saved settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reset'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await cartProvider.clearCart();
    await wishlistProvider.clear();
    await orderProvider.clearOrders();
    await settingsProvider.resetPreferences();
    await themeProvider.setDarkMode(false);
    await AuthService.resetAll();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final theme = context.watch<ThemeProvider>();
    final responsive = ResponsiveLayout.of(context);

    if (settings.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const SportsLogo(size: 28, showText: false)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth > responsive.maxContentWidth
              ? responsive.maxContentWidth
              : constraints.maxWidth;
          return Center(
            child: SizedBox(
              width: contentWidth,
              child: ListView(
                padding: EdgeInsets.all(responsive.pagePadding),
                children: [
                  SizedBox(
                    height: 108,
                    child: PromoBanner(
                      title: 'Your Account Control Center',
                      subtitle: 'Manage profile, preferences, and privacy in one place.',
                      cta: 'Review Settings',
                      icon: Icons.tune_outlined,
                      gradient: LinearGradient(
                        colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tip: Keep notifications on for order updates.'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _section(
            title: 'User Details',
            child: Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Name is required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Email is required';
                      if (!RegExp('^[^@\\s]+@[^@\\s]+\\.[^@\\s]+\$')
                          .hasMatch(email)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, rowConstraints) {
                      final compact = rowConstraints.maxWidth < 450;
                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _showPasswordDialog,
                              icon: const Icon(Icons.lock_reset),
                              label: const Text('Change Password'),
                            ),
                            const SizedBox(height: 10),
                            FilledButton(
                              onPressed: _profileSaving ? null : _saveProfile,
                              child: _profileSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Save Profile'),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _showPasswordDialog,
                              icon: const Icon(Icons.lock_reset),
                              label: const Text('Change Password'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton(
                              onPressed: _profileSaving ? null : _saveProfile,
                              child: _profileSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Save Profile'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _section(
            title: 'Contact Details',
            child: Form(
              key: _contactFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Delivery address',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _contactSaving ? null : _saveContact,
                      child: _contactSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Contact'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _section(
            title: 'Preferences',
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark mode'),
                  value: theme.isDark,
                  onChanged: (value) => theme.setDarkMode(value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Push notifications'),
                  value: settings.pushNotifications,
                  onChanged: (value) => settings.setPushNotifications(value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Order updates'),
                  value: settings.orderUpdates,
                  onChanged: (value) => settings.setOrderUpdates(value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Personalized offers'),
                  value: settings.personalizedOffers,
                  onChanged: (value) =>
                      settings.setPersonalizedOffers(value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Biometric lock'),
                  value: settings.biometricLock,
                  onChanged: (value) => settings.setBiometricLock(value),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: ValueKey('currency-${settings.currency}'),
                  initialValue: settings.currency,
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    prefixIcon: Icon(Icons.currency_exchange),
                  ),
                  items: _currencies
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.setCurrency(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey('language-${settings.language}'),
                  initialValue: settings.language,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: _languages
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.setLanguage(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey('sport-${settings.preferredSport}'),
                  initialValue: settings.preferredSport,
                  decoration: const InputDecoration(
                    labelText: 'Preferred sport',
                    prefixIcon: Icon(Icons.sports_soccer_outlined),
                  ),
                  items: _sports
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.setPreferredSport(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _section(
            title: 'App Management',
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: const Text('Clear cart'),
                  onTap: () async {
                    final cartProvider = context.read<CartProvider>();
                    await cartProvider.clearCart();
                    if (!mounted) return;
                    _showMessage('Cart cleared.');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.refresh_outlined),
                  title: const Text('Reset preferences'),
                  onTap: () async {
                    await settings.resetPreferences();
                    if (!mounted) return;
                    _phoneController.clear();
                    _addressController.clear();
                    _showMessage('Preferences reset.');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Clear wishlist'),
                  onTap: () async {
                    await context.read<WishlistProvider>().clear();
                    if (!mounted) return;
                    _showMessage('Wishlist cleared.');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Clear order history'),
                  onTap: () async {
                    await context.read<OrderProvider>().clearOrders();
                    if (!mounted) return;
                    _showMessage('Order history cleared.');
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: _logout,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_forever_outlined,
                      color: AppStyle.danger),
                  title: const Text(
                    'Factory reset app',
                    style: TextStyle(color: AppStyle.danger),
                  ),
                  onTap: _factoryReset,
                ),
              ],
            ),
          ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
