import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Upload image to Firebase Storage
  static Future<String> uploadImage(File imageFile, String itemId) async {
    try {
      final ref = _storage.ref().child('item_images').child('$itemId.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload item to Firestore
  static Future<void> uploadItem(ItemModel item, File imageFile) async {
    try {
      // Create document reference to get ID
      final docRef = _firestore.collection('items').doc();

      // Upload image with document ID
      final imageUrl = 'ajsfahf';

      // Create item with image URL and document ID
      final itemWithImage = item.copyWith(
        id: docRef.id,
        imageUrl: imageUrl,
      );

      // Save to Firestore
      await docRef.set(itemWithImage.toMap());

      // Update user's total uploaded items count
      await _updateUserStats(item.userId, 'uploaded');

    } catch (e) {
      throw Exception('Failed to upload item: $e');
    }
  }

  // Get user's items stream
  static Stream<List<ItemModel>> getUserItems(String userId) {
    return _firestore
        .collection('items')
        .where('userId', isEqualTo: userId)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get user's pending items
  static Stream<List<ItemModel>> getUserPendingItems(String userId) {
    return _firestore
        .collection('items')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get user's approved/rejected items for points page
  static Stream<List<ItemModel>> getUserReviewedItems(String userId) {
    return _firestore
        .collection('items')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['approved', 'rejected'])
        .orderBy('reviewDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Get user's total points
  static Future<int> getUserTotalPoints(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('items')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
          .get();

      int totalPoints = 0;
      for (var doc in querySnapshot.docs) {
        final item = ItemModel.fromMap(doc.data(), doc.id);
        totalPoints += item.assignedPoints;
      }

      return totalPoints;
    } catch (e) {
      print('Error getting user total points: $e');
      return 0;
    }
  }

  // Get user's total points stream
  static Stream<int> getUserTotalPointsStream(String userId) {
    return _firestore
        .collection('items')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
      int totalPoints = 0;
      for (var doc in snapshot.docs) {
        final item = ItemModel.fromMap(doc.data(), doc.id);
        totalPoints += item.assignedPoints;
      }
      return totalPoints;
    });
  }

  // Admin functions - Update item status
  static Future<void> updateItemStatus(
      String itemId,
      String status,
      int assignedPoints, {
        String? adminComments,
      }) async {
    try {
      await _firestore.collection('items').doc(itemId).update({
        'status': status,
        'assignedPoints': assignedPoints,
        'reviewDate': DateTime.now().millisecondsSinceEpoch,
        'adminComments': adminComments,
      });

      // If approved, update user's total points
      if (status == 'approved') {
        final doc = await _firestore.collection('items').doc(itemId).get();
        if (doc.exists) {
          final item = ItemModel.fromMap(doc.data()!, doc.id);
          await _updateUserStats(item.userId, 'approved');
        }
      }
    } catch (e) {
      throw Exception('Failed to update item status: $e');
    }
  }

  // Get all pending items for admin
  static Stream<List<ItemModel>> getAllPendingItems() {
    return _firestore
        .collection('items')
        .where('status', isEqualTo: 'pending')
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Create or update user profile
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'name': name,
        'totalUploaded': 0,
        'totalApproved': 0,
        'totalPoints': 0,
        'joinDate': DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user statistics
  static Future<void> _updateUserStats(String userId, String action) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      if (action == 'uploaded') {
        await userRef.update({
          'totalUploaded': FieldValue.increment(1),
        });
      } else if (action == 'approved') {
        await userRef.update({
          'totalApproved': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

  // Delete item (if needed)
  static Future<void> deleteItem(String itemId) async {
    try {
      // Get item data first
      final doc = await _firestore.collection('items').doc(itemId).get();
      if (doc.exists) {
        final item = ItemModel.fromMap(doc.data()!, doc.id);

        // Delete image from storage
        try {
          await _storage.refFromURL(item.imageUrl).delete();
        } catch (e) {
          print('Error deleting image: $e');
        }

        // Delete document
        await _firestore.collection('items').doc(itemId).delete();
      }
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}