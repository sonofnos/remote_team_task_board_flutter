import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/workspace.dart';

part 'workspace_model.g.dart';

@JsonSerializable()
class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.ownerId,
    required super.memberCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);

  factory WorkspaceModel.fromEntity(Workspace workspace) {
    return WorkspaceModel(
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      ownerId: workspace.ownerId,
      memberCount: workspace.memberCount,
      createdAt: workspace.createdAt,
      updatedAt: workspace.updatedAt,
    );
  }

  Workspace toEntity() {
    return Workspace(
      id: id,
      name: name,
      description: description,
      ownerId: ownerId,
      memberCount: memberCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
