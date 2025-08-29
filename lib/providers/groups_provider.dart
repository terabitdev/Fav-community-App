import 'package:flutter/material.dart';

class GroupsProvider with ChangeNotifier {
  final List<GroupModel> _groups = [
    GroupModel(
      id: '1',
      title: "Lincoln Elementary - 4th Grade 2026 - 2027",
      memberCount: 12,
      description: "Parent group for 4th grade students at Lincoln Elementary.",
      location: "Lincoln",
      joinedDate: "Joined Jan 2025",
      imageAsset: 'assets/images/city_skyline.jpg',
    ), GroupModel(
      id: '1',
      title: "Lincoln Elementary - 4th Grade 2026 - 2027",
      memberCount: 12,
      description: "Parent group for 4th grade students at Lincoln Elementary.",
      location: "Lincoln",
      joinedDate: "Joined Jan 2025",
      imageAsset: 'assets/images/city_skyline.jpg',
    ), GroupModel(
      id: '1',
      title: "Lincoln Elementary - 4th Grade 2026 - 2027",
      memberCount: 12,
      description: "Parent group for 4th grade students at Lincoln Elementary.",
      location: "Lincoln",
      joinedDate: "Joined Jan 2025",
      imageAsset: 'assets/images/city_skyline.jpg',
    ),
  ];

  List<GroupModel> get groups => List.unmodifiable(_groups);

  void addGroup(GroupModel group) {
    _groups.add(group);
    notifyListeners();
  }

  void removeGroup(String groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }

  void updateGroup(GroupModel updatedGroup) {
    final index = _groups.indexWhere((group) => group.id == updatedGroup.id);
    if (index != -1) {
      _groups[index] = updatedGroup;
      notifyListeners();
    }
  }
}

class GroupModel {
  final String id;
  final String title;
  final int memberCount;
  final String description;
  final String location;
  final String joinedDate;
  final String imageAsset;

  GroupModel({
    required this.id,
    required this.title,
    required this.memberCount,
    required this.description,
    required this.location,
    required this.joinedDate,
    required this.imageAsset,
  });

  GroupModel copyWith({
    String? id,
    String? title,
    int? memberCount,
    String? description,
    String? location,
    String? joinedDate,
    String? imageAsset,
  }) {
    return GroupModel(
      id: id ?? this.id,
      title: title ?? this.title,
      memberCount: memberCount ?? this.memberCount,
      description: description ?? this.description,
      location: location ?? this.location,
      joinedDate: joinedDate ?? this.joinedDate,
      imageAsset: imageAsset ?? this.imageAsset,
    );
  }
}