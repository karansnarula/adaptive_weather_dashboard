import 'package:equatable/equatable.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetail extends DetailEvent {
  final String postId;

  const LoadDetail(this.postId);

  @override
  List<Object> get props => [postId];
}

class RefreshDetail extends DetailEvent {
  const RefreshDetail();
}

class ToggleLikeOnDetail extends DetailEvent {
  const ToggleLikeOnDetail();
}

class SubmitComment extends DetailEvent {
  final String text;

  const SubmitComment(this.text);

  @override
  List<Object> get props => [text];
}

class DeleteCurrentPost extends DetailEvent {
  const DeleteCurrentPost();
}

class DeleteOneComment extends DetailEvent {
  final String commentId;

  const DeleteOneComment(this.commentId);

  @override
  List<Object> get props => [commentId];
}
