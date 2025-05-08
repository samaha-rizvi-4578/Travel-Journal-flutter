import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TravelJournal extends Equatable {
  final String id;
  final String placeName;
  final String? imageUrl;
  final String notes;
  final String mood;
  final bool visited;
  final String userId;
  final Timestamp createdAt;
  final double? latitude;
  final double? longitude;
  final int? budget; // Add budget field

  const TravelJournal({
    required this.id,
    required this.placeName,
    this.imageUrl,
    required this.notes,
    required this.mood,
    required this.visited,
    required this.userId,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.budget, // Initialize budget
  });

  TravelJournal copyWith({
    String? id,
    String? placeName,
    String? imageUrl,
    String? notes,
    String? mood,
    bool? visited,
    String? userId,
    Timestamp? createdAt,
    double? latitude,
    double? longitude,
    int? budget, // Add budget to copyWith
  }) {
    return TravelJournal(
      id: id ?? this.id,
      placeName: placeName ?? this.placeName,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      mood: mood ?? this.mood,
      visited: visited ?? this.visited,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      budget: budget ?? this.budget, // Copy budget
    );
  }

  @override
  List<Object?> get props => [
        id,
        placeName,
        imageUrl,
        notes,
        mood,
        visited,
        userId,
        createdAt,
        latitude,
        longitude,
        budget, // Add budget to props
      ];

  factory TravelJournal.fromMap(String id, Map<String, dynamic> map) {
    return TravelJournal(
      id: id,
      placeName: map['placeName'] ?? '',
      imageUrl: map['imageUrl'],
      notes: map['notes'] ?? '',
      mood: map['mood'] ?? '',
      visited: map['visited'] ?? false,
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      latitude: map['latitude'] is num ? map['latitude'].toDouble() : null,
      longitude: map['longitude'] is num ? map['longitude'].toDouble() : null,
      budget: map['budget'], // Parse budget from map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'imageUrl': imageUrl,
      'notes': notes,
      'mood': mood,
      'visited': visited,
      'userId': userId,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'budget': budget, // Add budget to map
    };
  }
}