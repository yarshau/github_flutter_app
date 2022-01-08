import 'package:bloc/bloc.dart';
import 'package:github_flutter_app/github_model.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:meta/meta.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final GitHubRepository gitHubRepository;
  final int id;
  final String name;

  DetailsCubit(this.gitHubRepository, this.id, this.name) : super(DetailsInitial()) {
    fetchData();
  }

  fetchData() async {
    final data = await gitHubRepository.gitDetails(id);
    print('$data');
    emit(DetailLoaded(info: data));
  }
}

@immutable
abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailLoaded extends DetailsState {
  RepoInfo info;

  DetailLoaded({required this.info});
}
