import 'package:flutter/material.dart';

import '../Widget/task_search.dart';
import 'custom_search_text_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            title: CustomSearchTextField(),
            toolbarHeight: 200,
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            hasScrollBody: false,
            child: TaskSearch(),
          )

        ]),
      ),
    );
  }
}
