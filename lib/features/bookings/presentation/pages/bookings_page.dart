import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().user?.uid;
    if (userId != null) {
      Future.microtask(() => context.read<BookingProvider>().fetchUserBookings(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'MY JOURNEYS', 
          style: TextStyle(
            letterSpacing: 4, 
            fontSize: 14, 
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : bookingProvider.bookings.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookingProvider.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookingProvider.bookings[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.02)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.black26 : const Color(0xFFFBFBFD),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.directions_car_filled_rounded, color: Color(0xFFD4AF37), size: 30),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'REF: ${booking.id.isEmpty ? "EXECUTIVE-ID" : booking.id.substring(0, 8).toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          color: isDark ? Colors.white38 : Colors.black26,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Elite Series Vehicle',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900, 
                                          fontSize: 17,
                                          color: isDark ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _StatusBadge(status: booking.status),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black12 : const Color(0xFFFBFBFD),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ITINERARY', 
                                      style: TextStyle(
                                        fontSize: 10, 
                                        color: isDark ? Colors.white38 : Colors.black38, 
                                        fontWeight: FontWeight.w800, 
                                        letterSpacing: 1
                                      )
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${DateFormat('MMM d').format(booking.startDate)} — ${DateFormat('MMM d, yyyy').format(booking.endDate)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700, 
                                        fontSize: 13, 
                                        color: isDark ? Colors.white70 : Colors.black87
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'INVESTMENT', 
                                      style: TextStyle(
                                        fontSize: 10, 
                                        color: isDark ? Colors.white38 : Colors.black38, 
                                        fontWeight: FontWeight.w800, 
                                        letterSpacing: 1
                                      )
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${booking.totalPrice.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900, 
                                        fontSize: 18, 
                                        color: isDark ? Colors.white : Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_motion_rounded, size: 80, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          const SizedBox(height: 32),
          Text(
            'NO ACTIVE JOURNEYS',
            style: TextStyle(
              fontSize: 14, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 4, 
              color: isDark ? Colors.white24 : Colors.black38
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your extraordinary drives will be listed here.',
            style: TextStyle(
              color: isDark ? Colors.white12 : Colors.black26, 
              fontSize: 13, 
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFFD4AF37) : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              minimumSize: const Size(220, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: const Text('DISCOVER FLEET', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
      ),
    );
  }
}
