import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  FirebaseFirestore? _firestore;
  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  BookingProvider() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      debugPrint("Firestore not initialized in BookingProvider: $e");
    }
  }

  Future<void> createBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_firestore != null) {
        await _firestore!.collection('bookings').add(booking.toFirestore());
        await fetchUserBookings(booking.userId);
      } else {
        // Mock success for demo
        _bookings.insert(0, booking);
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      debugPrint("Error creating booking: $e");
      if (_firestore == null) {
         _bookings.insert(0, booking); // Still add to mock if firebase fails
      } else {
        rethrow;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserBookings(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_firestore != null) {
        final snapshot = await _firestore!
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();
        _bookings = snapshot.docs.map((doc) => Booking.fromFirestore(doc.data(), doc.id)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching bookings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
