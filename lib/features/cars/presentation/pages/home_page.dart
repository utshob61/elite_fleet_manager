import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/car_provider.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../data/models/car_model.dart';
import 'car_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Prestige', 'Luxury SUV', 'Hypercar', 'Grand Tourer'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CarProvider>().fetchCars();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final carProvider = context.watch<CarProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(authProvider),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURATED COLLECTION',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select Your Path',
                    style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 32,
                        ),
                  ),
                  const SizedBox(height: 32),
                  const SearchField(),
                  const SizedBox(height: 40),
                  _buildCategoryFilter(),
                  const SizedBox(height: 48),
                  _buildSectionHeader('THE ELITE SELECTION'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 460,
              child: carProvider.isLoading
                  ? _buildShimmerList()
                  : AnimationLimiter(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: carProvider.getRecommendedCars().length,
                        itemBuilder: (context, index) {
                          final car = carProvider.getRecommendedCars()[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            child: SlideAnimation(
                              horizontalOffset: 150.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
                                  ),
                                  child: CarCard(car: car),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
              child: _buildSectionHeader('FULL INVENTORY'),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: carProvider.isLoading
                ? SliverToBoxAdapter(child: _buildShimmerList(vertical: true))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final car = carProvider.cars[index];
                        if (selectedCategory != 'All' && car.category != selectedCategory) {
                          return const SizedBox.shrink();
                        }
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          child: SlideAnimation(
                            verticalOffset: 100.0,
                            child: FadeInAnimation(
                              child: CarListTile(car: car),
                            ),
                          ),
                        );
                      },
                      childCount: carProvider.cars.length,
                    ),
                  ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(AuthProvider auth) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Text(
          'ELITE FLEET',
          style: TextStyle(
            color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
            letterSpacing: 6,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: theme.brightness == Brightness.light ? const Color(0xFFF0F0F0) : Colors.white10,
            child: Icon(Icons.notifications_none_rounded, color: theme.brightness == Brightness.light ? Colors.black : Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () => setState(() => selectedCategory = category),
              child: Column(
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                      letterSpacing: 2,
                      color: isSelected 
                          ? (theme.brightness == Brightness.light ? Colors.black : Colors.white)
                          : (theme.brightness == Brightness.light ? Colors.black26 : Colors.white24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    width: isSelected ? 20 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(2),
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

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: theme.brightness == Brightness.light ? Colors.black26 : Colors.white24,
          ),
        ),
        Icon(Icons.keyboard_arrow_right_rounded, color: theme.brightness == Brightness.light ? Colors.black26 : Colors.white24, size: 20),
      ],
    );
  }

  Widget _buildShimmerList({bool vertical = false}) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.brightness == Brightness.light ? Colors.grey[200]! : Colors.white10,
      highlightColor: theme.brightness == Brightness.light ? Colors.grey[50]! : Colors.white24,
      child: ListView.builder(
        scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
        shrinkWrap: vertical,
        physics: vertical ? const NeverScrollableScrollPhysics() : null,
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          width: vertical ? double.infinity : 300,
          height: vertical ? 140 : 450,
          margin: EdgeInsets.only(
            right: vertical ? 0 : 24,
            bottom: vertical ? 24 : 0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light ? Colors.white : Colors.white10,
        borderRadius: BorderRadius.circular(24),
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ] : null,
      ),
      child: TextField(
        style: TextStyle(color: theme.brightness == Brightness.light ? Colors.black : Colors.white),
        decoration: InputDecoration(
          hintText: 'Search collection...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.search_rounded, size: 24, color: theme.brightness == Brightness.light ? Colors.black45 : Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
        ),
      ),
    );
  }
}

class CarCard extends StatelessWidget {
  final Car car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                car.images.isNotEmpty ? car.images[0] : '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Icon(Icons.directions_car)),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.grey[100]);
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(50),
                      Colors.black.withAlpha(240),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 28,
              right: 28,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(120),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFD4AF37), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${car.rating}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 32,
              right: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.brand,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    car.model,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('PER DAY', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text(
                            '\$${car.pricePerDay}',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarListTile extends StatelessWidget {
  final Car car;
  const CarListTile({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarDetailsPage(car: car)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(32),
          boxShadow: theme.brightness == Brightness.light ? [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                car.images.isNotEmpty ? car.images[0] : '',
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.directions_car)),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.brand,
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    car.model,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 18, 
                      color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.light ? const Color(0xFFF8F8F8) : Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      car.category,
                      style: TextStyle(
                        color: theme.brightness == Brightness.light ? Colors.black45 : Colors.white54, 
                        fontSize: 9, 
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${car.pricePerDay}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 20,
                    color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  'Daily', 
                  style: TextStyle(
                    fontSize: 11, 
                    color: theme.brightness == Brightness.light ? Colors.black26 : Colors.white24, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
