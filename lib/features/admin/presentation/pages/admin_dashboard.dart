import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../cars/presentation/providers/car_provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = context.watch<CarProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'EXECUTIVE CONTROL', 
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatGrid(carProvider, isDark),
            const SizedBox(height: 48),
            Text(
              'FLEET MANAGEMENT', 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.w900, 
                letterSpacing: 3, 
                color: isDark ? Colors.white24 : Colors.black26
              )
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: carProvider.cars.length,
              itemBuilder: (context, index) {
                final car = carProvider.cars[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(5)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(
                      '${car.brand} ${car.model}', 
                      style: TextStyle(fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black)
                    ),
                    subtitle: Text(
                      '\$${car.pricePerDay}/day • ${car.category}',
                      style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.edit_rounded, color: isDark ? Colors.white60 : Colors.black45, size: 20), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20), onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 30),
      ),
    );
  }

  Widget _buildStatGrid(CarProvider carProvider, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('TOTAL FLEET', carProvider.cars.length.toString(), Icons.directions_car_rounded, isDark),
        _buildStatCard('ACTIVE TRIPS', '08', Icons.map_rounded, isDark),
        _buildStatCard('REVENUE', '\$12.5k', Icons.payments_rounded, isDark),
        _buildStatCard('AVG RATING', '4.9', Icons.star_rounded, isDark),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1, color: isDark ? Colors.white24 : Colors.black26)),
              Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}
