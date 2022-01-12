import 'package:bloc/bloc.dart';
import 'package:github_flutter_app/api/github_model.dart';
import 'package:github_flutter_app/db/github_repository.dart';
import 'package:meta/meta.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(
    this.gitHubRepository,
    this.id,
    this.name,
  ) : super(DetailsInitial()) {
    _fetchData();
  }

  final GitHubRepository gitHubRepository;
  final int id;
  final String name;

  void _fetchData() async {
    final data = await gitHubRepository.gitDetails(id);
    print('$data');
    emit(DetailLoaded(info: data));
  }
}

@immutable
abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class DetailLoaded extends DetailsState {
  DetailLoaded({required this.info});

  final RepoInfo info;
}
