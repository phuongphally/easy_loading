import 'dart:async';
import 'package:easy_loading/src/helpers/type_function.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';


/// A list view that can be used for incrementally loading items when the user scrolls.
/// This is an extension of the ListView widget that uses the ListView.builder constructor.
class EasyLoadingSliverGrid extends StatefulWidget {
  /// A callback that indicates if the collection associated with the ListView has more items that should be loaded
  final HasMore hasMore;

  /// A callback to an asynchronous function that would load more items
  final LoadMore loadMore;

  /// Determines when the list view should attempt to load more items based on of the index of the item is scrolling into view
  /// This is relative to the bottom of the list and has a default value of 0 so that it loads when the last item within the list view scrolls into view.
  /// As an example, setting this to 1 would attempt to load more items when the second last item within the list view scrolls into view
  final int loadMoreOffsetFromBottom;
  final Key key;
  final int crossAxisCount;
  
  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;
  
  final IndexedWidgetBuilder itemBuilder;
  final ItemCount itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  /// A callback that is triggered when more items are being loaded
  final OnLoadMore onLoadMore;

  /// A callback that is triggered when items have finished being loaded
  final OnLoadMoreFinished onLoadMoreFinished;

  EasyLoadingSliverGrid(
      {@required this.hasMore,
        @required this.loadMore,
        this.loadMoreOffsetFromBottom = 0,
        this.key,
        @required this.itemBuilder,
        @required this.itemCount,
        this.addAutomaticKeepAlives = true,
        this.addRepaintBoundaries = true,
        this.onLoadMore,
        this.onLoadMoreFinished,
        this.crossAxisCount,
        this.crossAxisSpacing,
        this.childAspectRatio
      });

  @override
  _EasyLoadingSliverGridState createState() {
    return _EasyLoadingSliverGridState();
  }
}

class _EasyLoadingSliverGridState extends State<EasyLoadingSliverGrid> {
  bool _loadingMore = false;
  final PublishSubject<bool> _loadingMoreSubject = PublishSubject<bool>();
  Stream<bool> _loadingMoreStream;

  @override
  void initState() {
    Future.microtask(() => _loadingMoreStream = _loadingMoreSubject.switchMap((shouldLoadMore) => loadMore()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _loadingMoreStream,
        builder: (context, snapshot) {
            return SliverGrid(
              key: widget.key,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: widget.crossAxisSpacing,
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                    (itemBuilderContext, index) {
                  if (!_loadingMore && index == widget.itemCount() - widget.loadMoreOffsetFromBottom - 1 && widget.hasMore()) {
                    _loadingMore = true;
                    _loadingMoreSubject.add(true);
                  }
                  return widget.itemBuilder(itemBuilderContext, index);
                },
                childCount: widget.itemCount(),
                addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
                addRepaintBoundaries: widget.addRepaintBoundaries,
              ),
          );
        });
  }

  Stream<bool> loadMore() async* {
    yield _loadingMore;
    if (widget.onLoadMore != null) {
      widget.onLoadMore();
    }
    await widget.loadMore();
    _loadingMore = false;
    yield _loadingMore;
    if (widget.onLoadMoreFinished != null) {
      widget.onLoadMoreFinished();
    }
  }

  @override
  void dispose() {
    _loadingMoreSubject.close();
    super.dispose();
  }
}