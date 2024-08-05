import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/services/fakeApi.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FakePage extends StatefulWidget {
  const FakePage({super.key});

  @override
  State<FakePage> createState() => _FakePageState();
}

class _FakePageState extends State<FakePage>
    with SingleTickerProviderStateMixin {
  static const _pageSize = 20;

  final PagingController _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future? _getData;

  initData() {
    _getData = _fetchPage(1);
  }

  _fetchPage(int pageKey) async {
    try {
      final newItems = await FakeApi().getPokemon(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
      return 'success';
    } catch (error) {
      _pagingController.error = error;
      return Future.error('$error');
    }
  }

  // Future<void> _fetchPage(int pageKey) async {
  //   try {
  //     final offset = pageKey * _pageSize;

  //     final newItems = await FakeApi().getPokemon(offset, _pageSize);

  //     final isLastPage = newItems.length < _pageSize;
  //     if (isLastPage) {
  //       _pagingController.appendLastPage(newItems);
  //     } else {
  //       final nextPageKey = pageKey + 1;
  //       _pagingController.appendPage(newItems, nextPageKey);
  //     }
  //   } catch (error) {
  //     _pagingController.error = error;
  //   }
  // }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                print('onRefresh');
                initData();
              },
              child: Text("Refresh"),
            ),
            TextButton(
              onPressed: () {
                print('onRefresh 2');
                initData();
              },
              child: Text("Refresh 2"),
            ),
            SizedBox(
              height: 500,
              child: PagedListView(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, dynamic item, index) => ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                    ),
                    title: Text('${item['url']}'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
