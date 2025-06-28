class ItemModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String category;
  final String itemName;
  final String location;
  final String contactNumber;
  final int amount;
  final double weight;
  final String imageUrl;
  final String status; // 'pending', 'approved', 'rejected'
  final int assignedPoints;
  final DateTime uploadDate;
  final DateTime? reviewDate;
  final String? adminComments;

  ItemModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.category,
    required this.itemName,
    required this.location,
    required this.contactNumber,
    required this.amount,
    required this.weight,
    required this.imageUrl,
    this.status = 'pending',
    this.assignedPoints = 0,
    required this.uploadDate,
    this.reviewDate,
    this.adminComments,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map, String id) {
    return ItemModel(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? '',
      category: map['category'] ?? '',
      itemName: map['itemName'] ?? '',
      location: map['location'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      amount: map['amount'] ?? 0,
      weight: (map['weight'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      status: map['status'] ?? 'pending',
      assignedPoints: map['assignedPoints'] ?? 0,
      uploadDate: DateTime.fromMillisecondsSinceEpoch(map['uploadDate'] ?? 0),
      reviewDate: map['reviewDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reviewDate'])
          : null,
      adminComments: map['adminComments'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'category': category,
      'itemName': itemName,
      'location': location,
      'contactNumber': contactNumber,
      'amount': amount,
      'weight': weight,
      'imageUrl': imageUrl,
      'status': status,
      'assignedPoints': assignedPoints,
      'uploadDate': uploadDate.millisecondsSinceEpoch,
      'reviewDate': reviewDate?.millisecondsSinceEpoch,
      'adminComments': adminComments,
    };
  }

  ItemModel copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? userName,
    String? category,
    String? itemName,
    String? location,
    String? contactNumber,
    int? amount,
    double? weight,
    String? imageUrl,
    String? status,
    int? assignedPoints,
    DateTime? uploadDate,
    DateTime? reviewDate,
    String? adminComments,
  }) {
    return ItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      category: category ?? this.category,
      itemName: itemName ?? this.itemName,
      location: location ?? this.location,
      contactNumber: contactNumber ?? this.contactNumber,
      amount: amount ?? this.amount,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      assignedPoints: assignedPoints ?? this.assignedPoints,
      uploadDate: uploadDate ?? this.uploadDate,
      reviewDate: reviewDate ?? this.reviewDate,
      adminComments: adminComments ?? this.adminComments,
    );
  }
}