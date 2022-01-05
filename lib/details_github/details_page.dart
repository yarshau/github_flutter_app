import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:github_flutter_app/details_github/details_cubit.dart';
import 'package:github_flutter_app/github_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  final int id;

  DetailsPage({required this.id}) : super();

  @override
  _DetailsPageState createState() => _DetailsPageState(id);
}

class _DetailsPageState extends State<DetailsPage> {
  double initX = 0;
  double initY = 0;

  var id;

  _DetailsPageState(this.id);


  @override
  Widget build(BuildContext context) {
    DetailsCubit _detailsCubit =
        DetailsCubit(Provider.of<GitHubRepository>(context), id);
    return BlocProvider(
        create: (_) => _detailsCubit,
        child: Material(
          child: Scaffold(
            body: Container(child: BlocBuilder<DetailsCubit, DetailsState>(
                builder: (BuildContext context, state) {
              if (state is DetailsInitial) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DetailLoaded) {
                List avatar = json.decode(state.info.avatarUrl);
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            Text('Full Name: ${state.info.fullName}'),
                            Text('Login: ${state.info.login}'),
                            Text('License Name: ${state.info.license}'),
                            GestureDetector(
                              child: Image.memory(
                                Uint8List.fromList(avatar.cast<int>()),
                                height: 350,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            InkWell(
                                onLongPress: () async {
                                  await launch('${state.info.url}',
                                      forceWebView: true);
                                },
                                child: Text('Url: ${state.info.url}')),
                            Text('Name: ${state.info.name}'),
                            Text('Desription: ${state.info.description}'),
                            Text(
                                'OrganizationUrl: ${state.info.organizationsUrl}'),
                            Text('Created Date: ${state.info.createdDate}'),
                            Text('Languages: ${state.info.language}'),
                            Text('License: ${state.info.watchers}'),
                          ],
                        ),
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
