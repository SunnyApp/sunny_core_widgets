import 'package:flutter/widgets.dart';
import 'package:sunny_core_widgets/container/spaced.dart';

Widget sliverBox(Widget widget, [bool wrap = true]) =>
    wrap == true ? SliverToBoxAdapter(child: widget) : widget;

WidgetBuilder buildSliverBox(WidgetBuilder builder) =>
    (context) => sliverBox(builder(context));

List<Widget> sliverBoxes(Iterable<Widget> widgets) =>
    widgets.map((widget) => SliverToBoxAdapter(child: widget)).toList();

class SimpleSliverList<W> extends StatelessWidget {
  final Iterable<W> itemsIter;
  final Widget Function(BuildContext context, W item) builder;

  const SimpleSliverList(this.itemsIter, {Key key, this.divider, this.builder})
      : super(key: key);

  final Widget divider;

  @override
  Widget build(BuildContext context) {
    final itemsIter = this.itemsIter ?? const [];
    final items = itemsIter.toList();
    final hasDivider = divider != null;
    final count = hasDivider ? ((items.length * 2) - 1) : items.length;
    return items.isEmpty
        ? sliverEmptyBox
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, idx) {
                if (items == null) return emptyBox;
                if (idx.isOdd && hasDivider) {
                  return divider;
                }
                idx = hasDivider ? idx ~/ 2 : idx.toInt();
                final item = items[idx];
                return builder(context, item);
              },
              childCount: count,
              addAutomaticKeepAlives: false,
            ),
          );
  }
}
