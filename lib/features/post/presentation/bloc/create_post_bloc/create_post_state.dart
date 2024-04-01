part of 'create_post_bloc.dart';

sealed class CreatePostState {
  const CreatePostState();
}

class CreatePostInitial extends CreatePostState {}

class FirstDataCollectSuccessState extends CreatePostState {
  FirstDataCollectSuccessState() {
    log("on success sate");
  }
}

class FirstDataCollectFailState extends CreatePostState {
  final String message;
  final String description;
  FirstDataCollectFailState({
    required this.message,
    required this.description,
  }) {
    log("on first fail collection");
  }
}

class SecondDataCollectFailState extends CreatePostState {
  final String message;
  final String description;
  SecondDataCollectFailState({
    required this.message,
    required this.description,
  }) {
    log("$message $description");
  }
}

class RemoteDataAddSuccessState extends CreatePostState {}

class RemoteDataAddFailState extends CreatePostState {
  final String message;
  final String description;
  RemoteDataAddFailState({
    required this.message,
    required this.description,
  });
}

class CreatPostLoadingState extends CreatePostState {}
