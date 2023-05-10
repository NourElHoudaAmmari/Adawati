import 'dart:core';

class DemandeModel {
  final id, description, userId, userName, userEmail;
 final DateTime createdAt;

  DemandeModel({
    this.id,
    this.description,
    this.userId,
    this.userName,
    this.userEmail,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> add_data() {
    return {
      "id": id,
      "description": description,
      "userId": userId,
      "userName": userName,
      "userEmail": userEmail,
      "createdAt": DateTime.now()
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'createdAt': createdAt,
    };
  }
}
