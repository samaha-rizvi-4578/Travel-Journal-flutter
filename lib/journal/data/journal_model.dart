import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TravelJournal extends Equatable {
  final String id;
  final String placeName;
  final String? imageUrl;
  final String notes;
  final String mood;
  final bool visited;
  final String userEmail; // Replace userId with userEmail
  final Timestamp createdAt;
  final double? latitude;
  final double? longitude;
  final int? budget;

  const TravelJournal({
    required this.id,
    required this.placeName,
    this.imageUrl,
    required this.notes,
    required this.mood,
    required this.visited,
    required this.userEmail, // Initialize userEmail
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.budget,
  });

  TravelJournal copyWith({
    String? id,
    String? placeName,
    String? imageUrl,
    String? notes,
    String? mood,
    bool? visited,
    String? userEmail, // Replace userId with userEmail
    Timestamp? createdAt,
    double? latitude,
    double? longitude,
    int? budget,
  }) {
    return TravelJournal(
      id: id ?? this.id,
      placeName: placeName ?? this.placeName,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      mood: mood ?? this.mood,
      visited: visited ?? this.visited,
      userEmail: userEmail ?? this.userEmail, // Copy userEmail
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      budget: budget ?? this.budget,
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
        userEmail, // Replace userId with userEmail
        createdAt,
        latitude,
        longitude,
        budget,
      ];

  factory TravelJournal.fromMap(String id, Map<String, dynamic> map) {
    return TravelJournal(
      id: id,
      placeName: map['placeName'] ?? '',
      imageUrl: map['imageUrl'],
      notes: map['notes'] ?? '',
      mood: map['mood'] ?? '',
      visited: map['visited'] ?? false,
      userEmail: map['userEmail'] ?? '', // Replace userId with userEmail
      createdAt: map['createdAt'] ?? Timestamp.now(),
      latitude: map['latitude'] is num ? map['latitude'].toDouble() : null,
      longitude: map['longitude'] is num ? map['longitude'].toDouble() : null,
      budget: map['budget'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'imageUrl': imageUrl,
      'notes': notes,
      'mood': mood,
      'visited': visited,
      'userEmail': userEmail, // Replace userId with userEmail
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'budget': budget,
    };
  }
}