import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/item_model.dart';

class FirebaseService {
  static bool _initialized = false;

  // Auto-initialize Firebase if not already done
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await Firebase.initializeApp();
      _initialized = true;
    }
  }

  // Getters with auto-initialization
  static Future<FirebaseFirestore> get firestore async {
    await _ensureInitialized();
    return FirebaseFirestore.instance;
  }

  static Future<FirebaseStorage> get storage async {
    await _ensureInitialized();
    return FirebaseStorage.instance;
  }

  static Future<FirebaseAuth> get auth async {
    await _ensureInitialized();
    return FirebaseAuth.instance;
  }

  // Get current user - FIXED: Now returns User? directly instead of Future<User?>
  static User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  // Alternative async method if you need to ensure initialization
  static Future<User?> getCurrentUserAsync() async {
    final authInstance = await auth;
    return authInstance.currentUser;
  }

  // Upload image to Firebase Storage
  static Future<String> uploadImage(File imageFile, String itemId) async {
    try {
      final storageInstance = await storage;
      final ref = storageInstance.ref().child('item_images').child('$itemId.jpg');
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
      final firestoreInstance = await firestore;

      // Create document reference to get ID
      final docRef = firestoreInstance.collection('items').doc();

      // Upload image with document ID
      final imageUrl = await uploadImage(imageFile, docRef.id);

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
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('userId', isEqualTo: userId)
            .orderBy('uploadDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get user's pending items
  static Stream<List<ItemModel>> getUserPendingItems(String userId) {
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'pending')
            .orderBy('uploadDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get user's approved/rejected items for points page
  static Stream<List<ItemModel>> getUserReviewedItems(String userId) {
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('userId', isEqualTo: userId)
            .where('status', whereIn: ['approved', 'rejected'])
            .orderBy('reviewDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get user's total points
  static Future<int> getUserTotalPoints(String userId) async {
    try {
      final firestoreInstance = await firestore;
      final querySnapshot = await firestoreInstance
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
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
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
        }));
  }

  // Admin functions - Update item status
  static Future<void> updateItemStatus(
      String itemId,
      String status,
      int assignedPoints, {
        String? adminComments,
      }) async {
    try {
      final firestoreInstance = await firestore;
      await firestoreInstance.collection('items').doc(itemId).update({
        'status': status,
        'assignedPoints': assignedPoints,
        'reviewDate': DateTime.now().millisecondsSinceEpoch,
        'adminComments': adminComments,
      });

      // If approved, update user's total points
      if (status == 'approved') {
        final doc = await firestoreInstance.collection('items').doc(itemId).get();
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
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('status', isEqualTo: 'pending')
            .orderBy('uploadDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get all approved items for admin
  static Stream<List<ItemModel>> getAllApprovedItems() {
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('status', isEqualTo: 'approved')
            .orderBy('reviewDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get all rejected items for admin
  static Stream<List<ItemModel>> getAllRejectedItems() {
    return Stream.fromFuture(firestore).asyncExpand((firestoreInstance) =>
        firestoreInstance
            .collection('items')
            .where('status', isEqualTo: 'rejected')
            .orderBy('reviewDate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => ItemModel.fromMap(doc.data(), doc.id))
            .toList()));
  }

  // Get analytics data for admin dashboard
  static Stream<Map<String, dynamic>> getAnalyticsData() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return _calculateAnalytics();
    }).asyncMap((_) => _calculateAnalytics());
  }

  // Calculate analytics data
  static Future<Map<String, dynamic>> _calculateAnalytics() async {
    try {
      final firestoreInstance = await firestore;

      // Get all items
      final itemsSnapshot = await firestoreInstance.collection('items').get();
      final items = itemsSnapshot.docs;

      // Count items by status
      int pendingItems = 0;
      int approvedItems = 0;
      int rejectedItems = 0;
      int totalPointsAwarded = 0;

      for (var doc in items) {
        final data = doc.data();
        final status = data['status'] ?? 'pending';

        switch (status) {
          case 'pending':
            pendingItems++;
            break;
          case 'approved':
            approvedItems++;
            totalPointsAwarded += (data['assignedPoints'] ?? 0) as int;
            break;
          case 'rejected':
            rejectedItems++;
            break;
        }
      }

      // Get total users
      final usersSnapshot = await firestoreInstance.collection('users').get();
      final totalUsers = usersSnapshot.docs.length;

      return {
        'totalItems': items.length,
        'pendingItems': pendingItems,
        'approvedItems': approvedItems,
        'rejectedItems': rejectedItems,
        'totalUsers': totalUsers,
        'totalPointsAwarded': totalPointsAwarded,
      };
    } catch (e) {
      print('Error calculating analytics: $e');
      return {
        'totalItems': 0,
        'pendingItems': 0,
        'approvedItems': 0,
        'rejectedItems': 0,
        'totalUsers': 0,
        'totalPointsAwarded': 0,
      };
    }
  }

  // Create or update user profile
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    required String name,
  }) async {
    try {
      final firestoreInstance = await firestore;
      await firestoreInstance.collection('users').doc(userId).set({
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
      final firestoreInstance = await firestore;
      final doc = await firestoreInstance.collection('users').doc(userId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user statistics
  static Future<void> _updateUserStats(String userId, String action) async {
    try {
      final firestoreInstance = await firestore;
      final userRef = firestoreInstance.collection('users').doc(userId);

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
      final firestoreInstance = await firestore;
      final storageInstance = await storage;

      // Get item data first
      final doc = await firestoreInstance.collection('items').doc(itemId).get();
      if (doc.exists) {
        final item = ItemModel.fromMap(doc.data()!, doc.id);

        // Delete image from storage
        try {
          await storageInstance.refFromURL(item.imageUrl).delete();
        } catch (e) {
          print('Error deleting image: $e');
        }

        // Delete document
        await firestoreInstance.collection('items').doc(itemId).delete();
      }
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}