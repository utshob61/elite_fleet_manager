class Car {
  final String id;
  final String brand;
  final String model;
  final String category;
  final double pricePerDay;
  final String fuelType;
  final String transmission;
  final List<String> images;
  final bool isAvailable;
  final double rating;
  final int reviewsCount;
  final Map<String, dynamic> specs;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.category,
    required this.pricePerDay,
    required this.fuelType,
    required this.transmission,
    required this.images,
    required this.isAvailable,
    required this.rating,
    required this.reviewsCount,
    required this.specs,
  });

  factory Car.fromFirestore(Map<String, dynamic> data, String id) {
    return Car(
      id: id,
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      category: data['category'] ?? '',
      pricePerDay: (data['pricePerDay'] ?? 0.0).toDouble(),
      fuelType: data['fuelType'] ?? '',
      transmission: data['transmission'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      specs: data['specs'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'brand': brand,
      'model': model,
      'category': category,
      'pricePerDay': pricePerDay,
      'fuelType': fuelType,
      'transmission': transmission,
      'images': images,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'specs': specs,
    };
  }
}
