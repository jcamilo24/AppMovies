import 'package:flutter/material.dart';

import 'widgets/movies_and_series/trending_list.dart';
import 'widgets/performers/trending_performers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 19),
          child: Center(
            child: LayoutBuilder(
              builder: (_, constraints) => RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Column(
                      children: const [
                        TrendingList(),
                        SizedBox(
                          height: 15,
                        ),
                        TrendingPerformers(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
