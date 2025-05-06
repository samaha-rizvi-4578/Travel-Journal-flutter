// lib/journal/data/journal_model.dart
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

  const TravelJournal({
    required this.id,
    required this.placeName,
    this.imageUrl,
    required this.notes,
    required this.mood,
    required this.visited,
    required this.userId,
    required this.createdAt,
  });

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
    };
  }
}