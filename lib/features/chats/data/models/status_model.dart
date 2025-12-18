import '../../domain/entities/status_entity.dart';

class StatusModel extends StatusEntity {
  StatusModel({required super.id, required super.isRead});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(id: json['_id'] ?? '', isRead: json['isRead'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, 'isRead': isRead};
  }
}
