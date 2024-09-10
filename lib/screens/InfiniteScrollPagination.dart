import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollPagination extends StatefulWidget {
  const InfiniteScrollPagination({super.key});

  @override
  State<InfiniteScrollPagination> createState() => _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  dispose() {
    super.dispose();
    _pagingController.dispose();
  }

  final PagingController _pagingController = PagingController(firstPageKey: 0);
  int _pageSize = 10;
  int currentPage = 1;
  List mockupList = List.generate(100, (index) => index);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getItemsPerPage(mockupList, pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize ? true : false;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  getItemsPerPage<T>(List<T> items, int pageIndex, int pageSize) async {
    int startIndex = pageIndex * pageSize;
    int endIndex = startIndex + pageSize;
    endIndex = endIndex > items.length ? items.length : endIndex;
    await Future.delayed(Duration(milliseconds: 300));
    return items.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // แบบ Infinite_scroll_pagination GridView
        SizedBox(
          height: 500,
          child: PagedGridView(
            shrinkWrap: true,
            pagingController: _pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 4,
              mainAxisExtent: 450,
            ),
            builderDelegate: PagedChildBuilderDelegate(
                noItemsFoundIndicatorBuilder: (context) {
                  return Text('empty');
                },
                noMoreItemsIndicatorBuilder: (context) => Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text('No more items')),
                      ),
                    ),
                itemBuilder: (context, item, index) => Text('$index test test test')),
          ),
        ),
      ],
    );
  }
}
