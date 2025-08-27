// // 1. DATA MODEL FILE - Save this as: lib/models/request_data.dart
// class RequestData {
//   final String userName;
//   final String timeAgo;
//   final String requestTitle;
//   final String requestDescription;
//   final String distance;
//   final String price;
//   final String requestType;

//   RequestData({
//     required this.userName,
//     required this.timeAgo,
//     required this.requestTitle,
//     required this.requestDescription,
//     required this.distance,
//     required this.price,
//     required this.requestType,
//   });
// }


// lib/models/request_data.dart
class RequestData {
  final String userName;
  final String timeAgo;
  final String requestTitle;
  final String requestDescription;
  final String distance;
  final String price;
  final String requestType;

  const RequestData({
    required this.userName,
    required this.timeAgo,
    required this.requestTitle,
    required this.requestDescription,
    required this.distance,
    required this.price,
    required this.requestType,
  });

  // Copy with method for future updates
  RequestData copyWith({
    String? userName,
    String? timeAgo,
    String? requestTitle,
    String? requestDescription,
    String? distance,
    String? price,
    String? requestType,
  }) {
    return RequestData(
      userName: userName ?? this.userName,
      timeAgo: timeAgo ?? this.timeAgo,
      requestTitle: requestTitle ?? this.requestTitle,
      requestDescription: requestDescription ?? this.requestDescription,
      distance: distance ?? this.distance,
      price: price ?? this.price,
      requestType: requestType ?? this.requestType,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestData &&
        other.userName == userName &&
        other.timeAgo == timeAgo &&
        other.requestTitle == requestTitle &&
        other.requestDescription == requestDescription &&
        other.distance == distance &&
        other.price == price &&
        other.requestType == requestType;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        timeAgo.hashCode ^
        requestTitle.hashCode ^
        requestDescription.hashCode ^
        distance.hashCode ^
        price.hashCode ^
        requestType.hashCode;
  }

  @override
  String toString() {
    return 'RequestData(userName: $userName, requestType: $requestType, requestTitle: $requestTitle)';
  }
}

class Request {
  final String id;
  final String userId;
  final String userName;
  final String requestTitle;
  final String requestDescription;
  final String requestType;
  final String? pickupLocation;
  final String? destinationLocation;
  final List<String> imageUrls;
  final bool isRecurring;
  final String frequency;
  final List<String> selectedDays;
  final String? timeRange;
  final DateTime? startDate;
  final bool offerPayment;
  final String? suggestedFee;
  final String? groupId;
  final DateTime createdAt;
  final String status;
  final String? distance;

  Request({
    required this.id,
    required this.userId,
    required this.userName,
    required this.requestTitle,
    required this.requestDescription,
    required this.requestType,
    this.pickupLocation,
    this.destinationLocation,
    this.imageUrls = const [],
    this.isRecurring = false,
    this.frequency = 'Weekly',
    this.selectedDays = const [],
    this.timeRange,
    this.startDate,
    this.offerPayment = false,
    this.suggestedFee,
    this.groupId,
    required this.createdAt,
    required this.status,
    this.distance,
  });

  RequestData toRequestData() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    String timeAgo;
    
    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }
    
    return RequestData(
      userName: userName,
      timeAgo: timeAgo,
      requestTitle: requestTitle,
      requestDescription: requestDescription,
      distance: distance ?? '0.0 km',
      price: suggestedFee ?? 'Free',
      requestType: requestType,
    );
  }

  Request copyWith({
    String? id,
    String? userId,
    String? userName,
    String? requestTitle,
    String? requestDescription,
    String? requestType,
    String? pickupLocation,
    String? destinationLocation,
    List<String>? imageUrls,
    bool? isRecurring,
    String? frequency,
    List<String>? selectedDays,
    String? timeRange,
    DateTime? startDate,
    bool? offerPayment,
    String? suggestedFee,
    String? groupId,
    DateTime? createdAt,
    String? status,
    String? distance,
  }) {
    return Request(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      requestTitle: requestTitle ?? this.requestTitle,
      requestDescription: requestDescription ?? this.requestDescription,
      requestType: requestType ?? this.requestType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      imageUrls: imageUrls ?? this.imageUrls,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      timeRange: timeRange ?? this.timeRange,
      startDate: startDate ?? this.startDate,
      offerPayment: offerPayment ?? this.offerPayment,
      suggestedFee: suggestedFee ?? this.suggestedFee,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'requestTitle': requestTitle,
      'requestDescription': requestDescription,
      'requestType': requestType,
      'pickupLocation': pickupLocation,
      'destinationLocation': destinationLocation,
      'imageUrls': imageUrls,
      'isRecurring': isRecurring,
      'frequency': frequency,
      'selectedDays': selectedDays,
      'timeRange': timeRange,
      'startDate': startDate?.toIso8601String(),
      'offerPayment': offerPayment,
      'suggestedFee': suggestedFee,
      'groupId': groupId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'distance': distance,
    };
  }

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      requestTitle: json['requestTitle'],
      requestDescription: json['requestDescription'],
      requestType: json['requestType'],
      pickupLocation: json['pickupLocation'],
      destinationLocation: json['destinationLocation'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      isRecurring: json['isRecurring'] ?? false,
      frequency: json['frequency'] ?? 'Weekly',
      selectedDays: List<String>.from(json['selectedDays'] ?? []),
      timeRange: json['timeRange'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      offerPayment: json['offerPayment'] ?? false,
      suggestedFee: json['suggestedFee'],
      groupId: json['groupId'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
      distance: json['distance'],
    );
  }
}