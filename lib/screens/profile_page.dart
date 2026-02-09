import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_widgets.dart';
import 'booking_history_page.dart';
import '../auth/login.dart';
import 'manage_address_page.dart';
import 'my_vehicle_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data =
            await Supabase.instance.client
                .from('profiles')
                .select()
                .eq('id', user.id)
                .single();
        if (mounted) {
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _userData = {'full_name': 'New User', 'email': user.email};
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShortScreen = size.height < 700;
    final avatarSize = size.width * (isShortScreen ? 0.25 : 0.3);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: buildGlobalAppBar(context: context, title: "Profile"),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: isShortScreen ? 20 : 30),
                    // Avatar Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: avatarSize * 0.5,
                                color: const Color(0xFF01102B),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF01102B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userData?['full_name'] ?? "User Name",
                      style: TextStyle(
                        fontSize: isShortScreen ? 20 : 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF01102B),
                      ),
                    ),
                    Text(
                      _userData?['email'] ?? "",
                      style: TextStyle(
                        fontSize: isShortScreen ? 13 : 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isShortScreen ? 30 : 40),

                    // Menu Items
                    _buildMenuItem(
                      context,
                      "Your Profile",
                      icon: Icons.account_circle_outlined,
                      onTap: () => _showEditProfileDialog(),
                    ),
                    _buildMenuItem(
                      context,
                      "My Bookings",
                      icon: Icons.history_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingHistoryPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      "Manage Address",
                      icon: Icons.location_on_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageAddressPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      "My Vehicle",
                      icon: Icons.directions_car_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyVehiclesPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      "Settings",
                      icon: Icons.settings_outlined,
                    ),
                    _buildMenuItem(
                      context,
                      "Help Center",
                      icon: Icons.help_outline,
                    ),
                    _buildMenuItem(
                      context,
                      "Logout",
                      icon: Icons.logout,
                      isLogout: true,
                      onTap: _logout,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userData?['full_name']);
    final phoneController = TextEditingController(text: _userData?['phone']);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              "Edit Profile",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final user = Supabase.instance.client.auth.currentUser;
                  if (user != null) {
                    await Supabase.instance.client.from('profiles').upsert({
                      'id': user.id,
                      'full_name': nameController.text,
                      'phone': phoneController.text,
                      'email': user.email,
                    });
                    _fetchUserData();
                    if (mounted) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01102B),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title, {
    IconData? icon,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color:
                        isLogout ? Colors.redAccent : const Color(0xFF01102B),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isLogout ? Colors.redAccent : const Color(0xFF01102B),
                    ),
                  ),
                ),
                if (!isLogout)
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, color: Color(0xFFF0F0F0)),
        ),
      ],
    );
  }
}
