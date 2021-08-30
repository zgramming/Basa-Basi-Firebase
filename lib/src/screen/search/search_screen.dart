import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import './widgets/search_result.dart';

class SearchScreen extends StatefulWidget {
  static const routeNamed = '/search-screen';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseDatabase database = FirebaseDatabase();
  final TextEditingController _searchEmailController = TextEditingController();
  final debounce = Debouncer();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    debounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cari kawan bicara'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Consumer(
                builder: (context, ref, child) => TextFormFieldCustom(
                  controller: _searchEmailController,
                  disableOutlineBorder: false,
                  hintText: 'Cari berdasarkan email [zeffry.reynando@gmail.com]',
                  padding: const EdgeInsets.all(20.0),
                  prefixIcon: const Icon(FeatherIcons.mail),
                  onChanged: (value) {
                    if ((value.length) >= 3) {
                      debounce.run(() => ref.read(searchQueryEmail).state = value);
                    }
                  },
                  validator: (value) =>
                      ((value?.length ?? 0) < 3) ? 'Minimal pencarian 3 karakter' : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    physics: const BouncingScrollPhysics(),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Hasil Pencarian',
                          style: Constant().fontComfortaa.copyWith(
                                color: colorPallete.accentColor,
                              ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Sudah kenal',
                      //     style: Constant().fontComfortaa.copyWith(
                      //           color: colorPallete.accentColor,
                      //         ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Belum kenal',
                      //     style: Constant().fontComfortaa.copyWith(
                      //           color: colorPallete.accentColor,
                      //         ),
                      //   ),
                      // ),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        SearchResult(),
                        // KnownPeopleTabbar(),
                        // UnknownPeopleTabbar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
