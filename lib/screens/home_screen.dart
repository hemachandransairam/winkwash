import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'book_services_page.dart';
import 'booking_history_page.dart';
import 'profile_page.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const BookServicesPage(),
      const BookingHistoryPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_rounded,
                  Icons.home_outlined,
                  "Home",
                ),
                _buildNavItem(
                  1,
                  Icons.description,
                  Icons.description_outlined,
                  "Book",
                ),
                _buildNavItem(
                  2,
                  Icons.access_time_filled,
                  Icons.access_time,
                  "History",
                ),
                _buildNavItem(3, Icons.person, Icons.person_outline, "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, isSelected ? -12 : 0, 0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF01102B) : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: const Color(0xFF01102B).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ]
                        : null,
              ),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? Colors.white : Colors.grey[400],
                size: 26,
              ),
            ),
            if (isSelected) const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF01102B) : Colors.grey[400],
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  static const int _infinitePageCount = 10000;
  late final PageController _pageController;
  int _currentBannerPage = 0;
  Timer? _carouselTimer;
  // _isLoading is used for cancel action indication
  bool _isLoading = false;

  final List<Map<String, dynamic>> _banners = [
    {
      'colors': [const Color(0xFFFDC830), const Color(0xFFF37335)],
      'title': 'CARWASH SERVICE',
      'subtitle': 'AT YOUR\nPLACE!',
    },
    {
      'colors': [const Color(0xFF2193b0), const Color(0xFF6dd5ed)],
      'title': 'QUICK SERVICE',
      'subtitle': 'SAVE YOUR\nTIME!',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start at a large index in the middle for circular scrolling simulation
    _currentBannerPage = _infinitePageCount ~/ 2;
    _pageController = PageController(initialPage: _currentBannerPage);

    _carouselTimer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        _currentBannerPage++;
        _pageController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  // _fetchActiveBooking is removed as we use StreamBuilder

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width * 0.06;
    final bool isShortScreen = size.height < 700;
    final double headerHeight = size.height * (isShortScreen ? 0.25 : 0.28);
    final user = Supabase.instance.client.auth.currentUser;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: headerHeight,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/home_title.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.065,
                left: horizontalPadding,
                right: horizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.08,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF01102B),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    const Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Paris corner, Pudu..',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Banner Carousel Section
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentBannerPage = page;
                });
              },
              itemBuilder: (context, index) {
                final banner = _banners[index % _banners.length];
                return _buildBanner(
                  horizontalPadding,
                  size,
                  banner['colors'],
                  banner['title'],
                  banner['subtitle'],
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _buildIndicator(index),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Active Orders Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: const Text(
              'Active Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF01102B),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Supabase.instance.client
                  .from('bookings')
                  .stream(primaryKey: ['id'])
                  .eq('user_id', user?.id ?? '')
                  .order('created_at', ascending: false)
                  .limit(1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const SizedBox(); // Hide on error
                }

                final bookings = snapshot.data ?? [];
                Map<String, dynamic>? activeBooking;

                if (bookings.isNotEmpty) {
                  final booking = bookings.first;
                  final status =
                      (booking['status'] as String? ?? '').toLowerCase();
                  if (status == 'pending' || status == 'confirmed') {
                    activeBooking = booking;
                  }
                }

                if (activeBooking == null) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Active Orders',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Active orders will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${activeBooking['vehicle_brand']} ${activeBooking['vehicle_name']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF01102B),
                                ),
                              ),
                              Text(
                                activeBooking['vehicle_type'] ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (activeBooking['status'] == 'pending')
                                      ? const Color(0xFFFFF4E5)
                                      : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (activeBooking['status'] as String).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color:
                                    (activeBooking['status'] == 'pending')
                                        ? const Color(0xFFFF9800)
                                        : const Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${activeBooking['booking_date']} • ${activeBooking['booking_time']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF01102B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              activeBooking['address_text'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Rs. ${activeBooking['total_price']}",
                            style: const TextStyle(
                              color: Color(0xFF01102B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : OutlinedButton(
                                  onPressed:
                                      () => _showCancelDialog(
                                        activeBooking!['id'],
                                      ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cancel Order",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Recent History Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: const Text(
              'Recent History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF01102B),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 48,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Recent History',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking history will appear when the backend is initialized.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(String bookingId) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Cancel Order?"),
            content: const Text(
              "Are you sure you want to cancel this order? This action cannot be undone.",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "No, Keep it",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  // Show loading
                  setState(() => _isLoading = true);
                  try {
                    await Supabase.instance.client
                        .from('bookings')
                        .update({'status': 'Cancelled'})
                        .eq('id', bookingId);

                    if (mounted) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Order cancelled successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // StreamBuilder will auto-update
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error cancelling order: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  "Yes, Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildBanner(
    double padding,
    Size size,
    List<Color> colors,
    String tag,
    String title,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(
                      color: Color(0xFF01102B),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF01102B),
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -15,
              bottom: 0,
              top: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.55),
                child: Image.asset('assets/home_car.png', fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            (_currentBannerPage % _banners.length) == index
                ? const Color(0xFF01102B)
                : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF01102B),
        ),
      ),
    );
  }
}
