import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageListView extends StatefulWidget {
  PageListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    required this.totalPage,
    required this.thisPage,
    this.padding,
    this.itemExtent,
    this.shrinkWrap,
  }) : super(key: key);

  final RefreshCallback? onRefresh;
  final LoadMoreCallback? onLoadMore;
  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  final int totalPage;
  final int thisPage;

  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final bool? shrinkWrap;

  @override
  _PageListViewState createState() => _PageListViewState();
}

typedef RefreshCallback = Future<void> Function(int index);
typedef LoadMoreCallback = Future Function(int index);

class _PageListViewState extends State<PageListView> {
  /// 是否正在加载数据
  bool _isLoading = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final list = isEmpty()
        ? emptyWidget()
        : NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: ScrollController(),
              shrinkWrap: widget.shrinkWrap ?? false,
              itemCount: widget.onLoadMore == null ? widget.itemCount : widget.itemCount + 1,
              padding: widget.padding,
              itemExtent: widget.itemExtent,
              itemBuilder: (BuildContext context, int index) {
                /// 不需要加载更多则不需要添加FootView
                if (widget.onLoadMore == null) {
                  return widget.itemBuilder(context, index);
                } else {
                  return index < widget.itemCount ? widget.itemBuilder(context, index) : MoreWidget(widget.itemCount, widget.thisPage, widget.totalPage);
                }
              },
            ));
    final Widget child = RefreshIndicator(onRefresh: () => widget.onRefresh?.call(0) ?? Future.value(), child: list);
    return NotificationListener(
      onNotification: (ScrollNotification note) {
        /// 确保是垂直方向滚动，且滑动至底部
        if (note.metrics.pixels >= note.metrics.maxScrollExtent - 50 && note.metrics.axis == Axis.vertical) {
          timer?.cancel();
          timer = Timer.periodic(const Duration(milliseconds: 50), (time) {
            timer?.cancel();
            _loadMore();
          });
        }
        return true;
      },
      child: widget.onRefresh == null ? list : child,
    );
  }

  bool isEmpty() {
    return widget.itemCount == 0;
  }

  Widget emptyWidget() {
    return const Center(
      child: Text("暂无数据"),
    );
  }

  Future<void> _loadMore() async {
    if (widget.onLoadMore == null) {
      return;
    }
    if (_isLoading) {
      return;
    }
    if (widget.thisPage == widget.totalPage) {
      return;
    }
    _isLoading = true;
    await widget.onLoadMore!(widget.thisPage);
    _isLoading = false;
  }
}

class MoreWidget extends StatelessWidget {
  const MoreWidget(this.itemCount, this.thisPage, this.totalPage);

  final int itemCount;
  final int thisPage;
  final int totalPage;

  @override
  Widget build(BuildContext context) {
    // print("当前$itemCount >>>> $totalPage");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (thisPage < totalPage) const CupertinoActivityIndicator(),

          /// 只有一页的时候，就不显示FooterView了
          Text(totalPage > thisPage ? '正在加载中...' : '没有更多数据了~'),
        ],
      ),
    );
  }
}
