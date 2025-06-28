import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_model.dart';
import 'firebase_service.dart';

class UploadService {
  static Future<bool> uploadItem({
    required String category,
    required String itemName,
    required String location,
    required String contactNumber,
    required int amount,
    required double weight,
    required File imageFile,
  }) async {
    try {
      // Get current user
      final user = FirebaseService.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get user profile for name
      final userProfile = await FirebaseService.getUserProfile(user.uid);
      final userName = userProfile?['name'] ?? user.displayName ?? 'Unknown User';

      // Create item model
      final item = ItemModel(
        id: '', // Will be set by Firebase
        userId: user.uid,
        userEmail: user.email ?? '',
        userName: userName,
        category: category,
        itemName: itemName,
        location: location,
        contactNumber: contactNumber,
        amount: amount,
        weight: weight,
        imageUrl: '', // Will be set after upload
        status: 'pending',
        assignedPoints: 0,
        uploadDate: DateTime.now(),
      );

      // Upload item to Firebase
      await FirebaseService.uploadItem(item, imageFile);

      return true;
    } catch (e) {
      print('Error uploading item: $e');
      return false;
    }
  }

  static Future<List<ItemModel>> getUserPendingItems() async {
    try {
      final user = FirebaseService.currentUser;
      if (user == null) return [];

      // Get pending items as a future (for one-time fetch)
      return await FirebaseService.getUserPendingItems(user.uid).first;
    } catch (e) {
      print('Error getting pending items: $e');
      return [];
    }
  }

  static Stream<List<ItemModel>> getUserPendingItemsStream() {
    final user = FirebaseService.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseService.getUserPendingItems(user.uid);
  }

  static Stream<List<ItemModel>> getUserReviewedItemsStream() {
    final user = FirebaseService.currentUser;
    if (user == null) return Stream.value([]);

    return FirebaseService.getUserReviewedItems(user.uid);
  }

  static Stream<int> getUserTotalPointsStream() {
    final user = FirebaseService.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseService.getUserTotalPointsStream(user.uid);
  }

  static Future<int> getUserTotalPoints() async {
    try {
      final user = FirebaseService.currentUser;
      if (user == null) return 0;

      return await FirebaseService.getUserTotalPoints(user.uid);
    } catch (e) {
      print('Error getting total points: $e');
      return 0;
    }
  }

  // Validation helpers
  static String? validateItemName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item name is required';
    }
    if (value.trim().length < 2) {
      return 'Item name must be at least 2 characters';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete address';
    }
    return null;
  }

  static String? validateContactNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter a valid contact number';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    final amount = int.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value.trim());
    if (weight == null || weight <= 0) {
      return 'Please enter a valid weight';
    }
    return null;
  }
}