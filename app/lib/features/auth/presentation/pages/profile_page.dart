import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../../core/widgets/glass_container.dart';
import '../bloc/auth_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showEditProfileModal(BuildContext context, AuthState state) {
    final nameController = TextEditingController(text: state.currentUser?.displayName ?? '');
    final photoController = TextEditingController(text: state.currentUser?.profilePhotoUrl ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0xFF262C3A), width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.grey600, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('EDIT PROFILE',
                style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Display Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoController,
              decoration: const InputDecoration(
                  labelText: 'Profile Photo URL', prefixIcon: Icon(Icons.image_outlined)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      AuthUpdateProfileEvent(
                        displayName: nameController.text.trim(),
                        profilePhotoUrl: photoController.text.trim().isNotEmpty
                            ? photoController.text.trim()
                            : null,
                      ),
                    );
                Navigator.pop(modalContext);
                UiHelpers.showSnackBar(context, 'Profile updated successfully!', isSuccess: true);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _showServerConfigModal(BuildContext context) {
    final urlController =
        TextEditingController(text: SecureStorageService.getBaseUrl() ?? AppConfig.baseUrl);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: Color(0xFF262C3A), width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.grey600, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('SERVER & API CONFIG',
                style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              'Configure the Olympus backend host URL. Default is Android emulator (10.0.2.2:8080) or localhost (127.0.0.1:8080).',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey400),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                  labelText: 'Backend Base URL', prefixIcon: Icon(Icons.dns_outlined)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final newUrl = urlController.text.trim();
                if (newUrl.isNotEmpty) {
                  await SecureStorageService.setBaseUrl(newUrl);
                  AppConfig.baseUrl = newUrl;
                  if (context.mounted) {
                    Navigator.pop(modalContext);
                    UiHelpers.showSnackBar(context, 'Base URL updated to $newUrl', isSuccess: true);
                  }
                }
              },
              child: const Text('Apply Server URL'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.currentUser;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'ACCOUNT & SETTINGS',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile Card
              GlassContainer(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: user?.profilePhotoUrl != null && user!.profilePhotoUrl!.isNotEmpty
                          ? Image.network(
                              user.profilePhotoUrl!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _fallbackAvatar(user.displayName ?? 'Trader'),
                            )
                          : _fallbackAvatar(user?.displayName ?? 'Trader'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'Olympian Trader',
                            style: GoogleFonts.sora(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '@${user?.username ?? "trader"}',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.phone ?? authState.phone ?? '+1234567890',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey400),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primaryLight),
                      onPressed: () => _showEditProfileModal(context, authState),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // API & Network Section
              Text(
                'API & NETWORK PREFERENCES',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.grey400),
              ),
              const SizedBox(height: 12),

              GlassContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dns_rounded, color: AppColors.primaryLight),
                      title: Text('Backend Server URL',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      subtitle: Text(
                        SecureStorageService.getBaseUrl() ?? AppConfig.baseUrl,
                        style: GoogleFonts.inter(color: AppColors.grey400, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.grey500),
                      onTap: () => _showServerConfigModal(context),
                    ),
                    const Divider(color: Color(0xFF262C3A), height: 1),
                    SwitchListTile(
                      secondary: const Icon(Icons.offline_bolt_rounded, color: AppColors.warning),
                      title: Text('Seamless Mock Fallback',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      subtitle: Text(
                        'Allows full trading simulation when backend is offline',
                        style: GoogleFonts.inter(color: AppColors.grey400, fontSize: 12),
                      ),
                      value: AppConfig.enableMockFallback,
                      activeTrackColor: AppColors.primaryLight,
                      onChanged: (val) {
                        setState(() {
                          AppConfig.enableMockFallback = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security & Auth Section
              Text(
                'SECURITY & SESSION',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.grey400),
              ),
              const SizedBox(height: 12),

              GlassContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: AppColors.green),
                      title: Text('JWT Authentication',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      subtitle: Text(
                        authState.token != null ? 'Active Token Attached' : 'No Active Session',
                        style: GoogleFonts.inter(color: AppColors.grey400, fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'SECURED',
                          style: GoogleFonts.inter(
                              color: AppColors.green, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutEvent());
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signup, (route) => false);
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red.withOpacity(0.2),
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red, width: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackAvatar(String name) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U',
        style: GoogleFonts.sora(
            fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
      ),
    );
  }
}
