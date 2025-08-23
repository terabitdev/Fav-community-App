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