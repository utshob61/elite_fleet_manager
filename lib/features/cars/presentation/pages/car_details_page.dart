import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/car_model.dart';
import '../../bookings/presentation/providers/booking_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../bookings/data/models/booking_model.dart';

class CarDetailsPage extends StatelessWidget {
  final Car car;
  const CarDetailsPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.white10 : Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.white10 : Colors.black26,
              child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(isDark),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(context, isDark),
                  const SizedBox(height: 48),
                  _buildSectionLabel('PERFORMANCE CHARACTERISTICS', isDark),
                  const SizedBox(height: 24),
                  _buildSpecGrid(isDark),
                  const SizedBox(height: 48),
                  _buildSectionLabel('THE EXPERIENCE', isDark),
                  const SizedBox(height: 16),
                  Text(
                    'Crafted for those who demand the extraordinary. The ${car.brand} ${car.model} represents the pinnacle of automotive engineering and luxury. Every detail, from the hand-stitched interior to the effortless power delivery, is designed to provide an unparalleled journey.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 160),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildEliteBottomBar(context, isDark),
    );
  }

  Widget _buildHeroImage(bool isDark) {
    return Hero(
      tag: car.id,
      child: SizedBox(
        height: 550,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: car.images.isNotEmpty ? car.images[0] : '',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(color: Colors.grey[300]),
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
                      Colors.black.withAlpha(128),
                      Colors.transparent,
                      isDark ? Colors.black.withAlpha(230) : Colors.white.withAlpha(230),
                      isDark ? Colors.black : Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                car.brand,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                car.model,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 36, 
                  height: 1.0,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 22),
              const SizedBox(width: 8),
              Text(
                car.rating.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 3,
        color: isDark ? Colors.white24 : Colors.black26,
      ),
    );
  }

  Widget _buildSpecGrid(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: car.specs.entries.take(3).map((e) {
        return _SpecCard(
          icon: _getIconForSpec(e.key),
          label: e.value.toString(),
          sublabel: e.key.toUpperCase(),
          isDark: isDark,
        );
      }).toList(),
    );
  }

  IconData _getIconForSpec(String key) {
    key = key.toLowerCase();
    if (key.contains('0-60')) return Icons.speed_rounded;
    if (key.contains('hp') || key.contains('power') || key.contains('v12') || key.contains('v8')) return Icons.bolt_rounded;
    if (key.contains('top speed')) return Icons.timer_rounded;
    if (key.contains('luxury') || key.contains('interior')) return Icons.auto_awesome_rounded;
    return Icons.settings_rounded;
  }

  Widget _buildEliteBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RESERVATION COST', 
                style: TextStyle(
                  color: isDark ? Colors.white24 : Colors.black26, 
                  fontSize: 10, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 2
                )
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${car.pricePerDay}',
                      style: TextStyle(
                        fontSize: 32, 
                        fontWeight: FontWeight.w900, 
                        color: isDark ? Colors.white : Colors.black
                      ),
                    ),
                    TextSpan(
                      text: ' / day',
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.black38, 
                        fontSize: 14, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 48),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showBookingSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFD4AF37) : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Text('RESERVE NOW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingSheet(car: car),
    );
  }
}

class _SpecCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool isDark;

  const _SpecCard({required this.icon, required this.label, required this.sublabel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(12) : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(10)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 15)],
            ),
            child: Icon(icon, size: 24, color: const Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 20),
          Text(
            label, 
            textAlign: TextAlign.center, 
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 13, 
              color: isDark ? Colors.white : Colors.black87
            )
          ),
          const SizedBox(height: 6),
          Text(
            sublabel, 
            style: TextStyle(
              fontSize: 8, 
              color: isDark ? Colors.white24 : Colors.black26, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 1
            )
          ),
        ],
      ),
    );
  }
}

class _BookingSheet extends StatefulWidget {
  final Car car;
  const _BookingSheet({required this.car});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'RESERVATION ITINERARY',
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 4,
              color: isDark ? Colors.white70 : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          _DateSelector(
            label: 'COMMENCEMENT',
            date: _startDate,
            isDark: isDark,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _startDate = date);
            },
          ),
          const SizedBox(height: 24),
          _DateSelector(
            label: 'CONCLUSION',
            date: _endDate,
            isDark: isDark,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate ?? DateTime.now(),
                firstDate: _startDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) setState(() => _endDate = date);
            },
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: (_startDate == null || _endDate == null)
                ? null
                : () async {
                    final days = _endDate!.difference(_startDate!).inDays + 1;
                    final totalPrice = days * widget.car.pricePerDay;

                    final booking = Booking(
                      id: '',
                      userId: auth.user?.uid ?? 'executive-guest',
                      carId: widget.car.id,
                      startDate: _startDate!,
                      endDate: _endDate!,
                      totalPrice: totalPrice,
                      status: 'confirmed',
                      createdAt: DateTime.now(),
                    );

                    try {
                      await bookingProvider.createBooking(booking);
                      if (!mounted) return;
                      Navigator.pop(context);
                      _showEliteSuccessDialog(context, isDark);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFFD4AF37) : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 26),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              disabledBackgroundColor: isDark ? Colors.white10 : const Color(0xFFF0F0F0),
            ),
            child: const Text('CONFIRM EXCLUSIVE BOOKING', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showEliteSuccessDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, size: 100, color: Color(0xFFD4AF37)),
            const SizedBox(height: 40),
            Text(
              'ACCESS GRANTED', 
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                fontSize: 20, 
                letterSpacing: 4,
                color: isDark ? Colors.white : Colors.black,
              )
            ),
            const SizedBox(height: 16),
            Text(
              'Your reservation for the ${widget.car.brand} ${widget.car.model} is now confirmed. Our executive concierge will be in touch.',
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white60 : Colors.black45, height: 1.8, fontSize: 15),
            ),
            const SizedBox(height: 56),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'PROCEED', 
                style: TextStyle(
                  color: isDark ? const Color(0xFFD4AF37) : Colors.black, 
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 3, 
                  fontSize: 13
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final bool isDark;

  const _DateSelector({required this.label, required this.date, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 26),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withAlpha(12) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label, 
                  style: TextStyle(
                    fontSize: 10, 
                    color: isDark ? Colors.white24 : Colors.black26, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 2
                  )
                ),
                const SizedBox(height: 8),
                Text(
                  date == null ? 'SELECT DATE' : '${date!.day} / ${date!.month} / ${date!.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 18, 
                    color: isDark ? Colors.white : Colors.black87
                  ),
                ),
              ],
            ),
            const Icon(Icons.calendar_month_rounded, size: 28, color: Color(0xFFD4AF37)),
          ],
        ),
      ),
    );
  }
}
