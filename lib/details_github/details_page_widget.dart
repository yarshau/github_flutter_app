import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_flutter_app/details_github/details_bloc.dart';
import 'package:github_flutter_app/db/github_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.id, required this.name}) : super();

  final int id;
  final String name;

  @override
  _DetailsPageState createState() => _DetailsPageState(id, name);
}

class _DetailsPageState extends State<DetailsPage> {
  _DetailsPageState(this.id, this.name);

  final int id;
  final String name;
  late DetailsCubit _detailsCubit = DetailsCubit(Provider.of<GitHubRepository>(context), id, name);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _detailsCubit,
      child: Material(
        child: Scaffold(
          appBar: AppBar(title: Text(name)),
          body: Column(
            children: [
              const SizedBox(height: 15),
              BlocBuilder<DetailsCubit, DetailsState>(
                builder: (BuildContext context, state) {
                  if (state is DetailsInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DetailLoaded) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        print(constraints.maxWidth);
                        print(constraints.maxHeight);
                        if (constraints.maxWidth < 775) {
                          return _portraitLayout(state);
                        } else {
                          return _landscapeLayout(state);
                        }
                      },
                    );
                  } else {
                    return Text('No data found');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portraitLayout(DetailLoaded state) {
    final List avatar = json.decode(state.info.avatarUrl);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.85,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.memory(
                  Uint8List.fromList(avatar.cast<int>()),
                  height: 350,
                ),
                _defaultText('Login: ${state.info.login}'),
                IconButton(
                  onPressed: () async {
                    await launch('${state.info.url}', forceSafariVC: true);
                  },
                  icon: Icon(FontAwesomeIcons.github),
                  splashRadius: 10.0,
                  iconSize: 50,
                ),
                _defaultText('Full Name: ${state.info.fullName}'),
                _defaultText('License Name: ${state.info.license}'),
                _defaultText('Name: ${state.info.name}'),
                Container(width: 350, child: _defaultText('Desription: ${state.info.description}')),
                Container(
                  width: 350,
                  child: InkWell(
                      autofocus: true,
                      onLongPress: () async {
                        await launch('${state.info.url}', forceSafariVC: true);
                      },
                      child: _defaultText('OrganizationUrl: ${state.info.organizationsUrl}')),
                ),
                _defaultText('Created Date: ${state.info.createdDate}'),
                _defaultText('Languages: ${state.info.language}'),
                _defaultText('License: ${state.info.watchers}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _landscapeLayout(DetailLoaded state) {
    final List avatar = json.decode(state.info.avatarUrl);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 50),
            Column(
              children: [
                Image.memory(
                  Uint8List.fromList(avatar.cast<int>()),
                  height: MediaQuery.of(context).size.width * 0.25,
                ),
                _defaultText('Login: ${state.info.login}'),
                IconButton(
                  onPressed: () async {
                    await launch('${state.info.url}', forceSafariVC: true);
                  },
                  icon: Icon(FontAwesomeIcons.github),
                  splashRadius: 10.0,
                  iconSize: 50,
                ),
              ],
            ),
            const SizedBox(width: 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _defaultText('Full Name: ${state.info.fullName}'),
                    _defaultText('License Name: ${state.info.license}'),
                    _defaultText('Name: ${state.info.name}'),
                    Container(width: 400, child: _defaultText('Desription: ${state.info.description}')),
                    InkWell(
                        autofocus: true,
                        onLongPress: () async {
                          await launch('${state.info.url}', forceSafariVC: true);
                        },
                        child: _defaultText('OrganizationUrl: ${state.info.organizationsUrl}')),
                    _defaultText('Created Date: ${state.info.createdDate}'),
                    _defaultText('Languages: ${state.info.language}'),
                    _defaultText('License: ${state.info.watchers}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _defaultText(String toDisplay) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text(
        '$toDisplay',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
