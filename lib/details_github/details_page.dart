import 'package:flutter/material.dart';
import 'package:github_flutter_app/details_github/details_cubit.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final int id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailsCubit _detailsCubit = DetailsCubit(Provider.of<GitHubRepository>(context), id);
    return BlocProvider(
        create: (_) => _detailsCubit,
        child: Material(
          child: Scaffold(
            body: Container(child: BlocBuilder<DetailsCubit, DetailsState>(
                builder: (BuildContext context, state) {
              if (state is DetailsInitial) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DetailLoaded) {
                return Scaffold(
                  body: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Text('Full Name: ${state.info.fullName}'),
                        Text('Login: ${state.info.login}'),
                        Text('License Name: ${state.info.license}'),
                        Image.network('${state.info.avatarUrl}'),
                        InkWell(onLongPress: () async { await launch('${state.info.url}',forceWebView: true);}, child: Text('Url: ${state.info.url}')),
                        Text('Name: ${state.info.name}'),
                        Text('Desription: ${state.info.description}'),
                        Text('OrganizationUrl: ${state.info.organizationsUrl}'),
                        Text('Created Date: ${state.info.createdDate}'),
                        Text('Languages: ${state.info.language}'),
                        Text('License: ${state.info.watchers}'),
                      ],
                    ),
                  ),
                );
              } else {
                return Text('No data found');
              }
            })),
          ),
        ));
  }
}
