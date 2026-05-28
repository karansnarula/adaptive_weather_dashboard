import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../entities/weather_event_type.dart';
import '../repositories/discussion_repository.dart';

@injectable
class CreatePost {
  final DiscussionRepository _repository;

  const CreatePost(this._repository);

  Future<Either<Failure, Post>> call({
    required String title,
    required WeatherEventType? eventType,
    required String city,
    required String imageUrl,
    required String description,
  }) => _repository.createPost(
    title: title,
    eventType: eventType,
    city: city,
    imageUrl: imageUrl,
    description: description,
  );
}
