import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_widgets.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: buildGlobalAppBar(context: context, title: "Booking History"),
      body:
          user == null
              ? const Center(child: Text("Please login to view history"))
              : StreamBuilder<List<Map<String, dynamic>>>(
                stream: Supabase.instance.client
                    .from('bookings')
                    .stream(primaryKey: ['id'])
                    .eq('user_id', user.id)
                    .order('created_at', ascending: false),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text("Error: ${snapshot.error}"),
                          const SizedBox(height: 16),
                          const Text(
                            "Does the 'bookings' table exist in your Supabase?",
                          ),
                        ],
                      ),
                    );
                  }

                  final bookings = snapshot.data ?? [];

                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No Booking History Yet",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return _buildBookingCard(context, booking);
                    },
                  );
                },
              ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    final date = DateTime.parse(booking['created_at']);
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    final status = booking['status'] ?? 'Pending';
    final price = booking['total_price'] ?? 0;
    final isCancellable =
        status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                "Rs. $price",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Color(0xFF01102B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            booking['vehicle_name'] ?? "Car Wash Service",
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(height: 32, color: Color(0xFFF0F0F0)),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking['address_text'] ??
                      booking['address'] ??
                      "No address provided",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF01102B),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (isCancellable) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(context, booking['id']),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Cancel Booking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, String bookingId) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Cancel Booking?"),
            content: const Text(
              "Are you sure you want to cancel this booking? This action cannot be undone.",
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
                  try {
                    await Supabase.instance.client
                        .from('bookings')
                        .update({'status': 'Cancelled'})
                        .eq('id', bookingId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Booking cancelled successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error cancelling booking: $e"),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return const Color(0xFF01102B);
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return const Color(0xFF01102B);
    }
  }
}
