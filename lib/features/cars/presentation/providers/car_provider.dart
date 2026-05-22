import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/car_model.dart';

class CarProvider with ChangeNotifier {
  FirebaseFirestore? _firestore;
  List<Car> _cars = [];
  bool _isLoading = false;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;

  CarProvider() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      debugPrint("Firestore not initialized: $e");
    }
  }

  Future<void> fetchCars() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Production path
      if (_firestore != null) {
        final snapshot = await _firestore!.collection('cars').get();
        if (snapshot.docs.isNotEmpty) {
          _cars = snapshot.docs.map((doc) => Car.fromFirestore(doc.data(), doc.id)).toList();
        }
      }
      
      // Ultra-Premium Collection for the Extraordinary Experience
      if (_cars.isEmpty) {
        _cars = [
          Car(
            id: 'RR01',
            brand: 'ROLLS-ROYCE',
            model: 'PHANTOM VIII',
            category: 'Prestige',
            pricePerDay: 2500,
            fuelType: 'Petrol',
            transmission: 'Automatic',
            images: [
              'https://images.unsplash.com/photo-1631214499558-b7625608ec42?q=80&w=2070&auto=format&fit=crop',
              'https://images.unsplash.com/photo-1563720223185-11003d516905?q=80&w=2070&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 5.0,
            reviewsCount: 12,
            specs: {'V12': '563 HP', '0-60': '5.1s', 'Luxury': 'Starlight Headliner'},
          ),
          Car(
            id: 'MB01',
            brand: 'MAYBACH',
            model: 'GLS 600',
            category: 'Luxury SUV',
            pricePerDay: 800,
            fuelType: 'Hybrid',
            transmission: 'Automatic',
            images: [
              'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?q=80&w=2070&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 4.9,
            reviewsCount: 45,
            specs: {'V8': '550 HP', 'Suspension': 'E-Active Body', 'Seats': 'Reclining'},
          ),
          Car(
            id: 'LB01',
            brand: 'LAMBORGHINI',
            model: 'REVUELTO',
            category: 'Hypercar',
            pricePerDay: 3500,
            fuelType: 'Hybrid',
            transmission: 'DCT',
            images: [
              'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?q=80&w=2032&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 5.0,
            reviewsCount: 8,
            specs: {'V12 Hybrid': '1001 HP', '0-60': '2.5s', 'Top Speed': '217 MPH'},
          ),
          Car(
            id: 'FE01',
            brand: 'FERRARI',
            model: 'SF90 STRADALE',
            category: 'Hypercar',
            pricePerDay: 3200,
            fuelType: 'Hybrid',
            transmission: 'DCT',
            images: [
              'https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=2070&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 4.9,
            reviewsCount: 15,
            specs: {'V8 Plug-in': '986 HP', '0-60': '2.0s', 'Aero': 'Active Drag'},
          ),
          Car(
            id: 'BT01',
            brand: 'BENTLEY',
            model: 'CONTINENTAL GT',
            category: 'Grand Tourer',
            pricePerDay: 750,
            fuelType: 'Petrol',
            transmission: 'Automatic',
            images: [
              'https://images.unsplash.com/photo-1621135802920-133df287f89c?q=80&w=2070&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 4.8,
            reviewsCount: 67,
            specs: {'W12': '650 HP', 'Wood': 'Open Pore Walnut', 'Audio': 'Naim'},
          ),
          Car(
            id: 'AM01',
            brand: 'ASTON MARTIN',
            model: 'DBS VOLANTE',
            category: 'Grand Tourer',
            pricePerDay: 950,
            fuelType: 'Petrol',
            transmission: 'Automatic',
            images: [
              'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?q=80&w=2069&auto=format&fit=crop',
            ],
            isAvailable: true,
            rating: 4.9,
            reviewsCount: 22,
            specs: {'V12': '715 HP', 'Body': 'Carbon Fiber', 'Sound': 'Bang & Olufsen'},
          ),
        ];
      }
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? _preferredCategory;

  void setPreferredCategory(String category) {
    _preferredCategory = category;
    notifyListeners();
  }

  List<Car> getRecommendedCars() {
    if (_preferredCategory != null && _preferredCategory != 'All') {
      final preferred = _cars.where((car) => car.category == _preferredCategory).toList();
      final others = _cars.where((car) => car.category != _preferredCategory && car.rating >= 4.9).toList();
      return [...preferred, ...others];
    }
    // Default: Highlight the highest rated cars or top tier
    final recommended = _cars.where((car) => car.pricePerDay > 1000).toList();
    if (recommended.isEmpty) {
      return _cars.where((car) => car.rating >= 4.9).toList();
    }
    return recommended;
  }
}
