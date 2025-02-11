import 'package:flutter/material.dart';

/// A class that extends [RowBuilderParams] to provide parameters for action builders
class ActionParamBuilder extends RowBuilderParams {
  /// The index of the row in the table
  final int rowIndex;

  /// Creates an [ActionParamBuilder] instance
  ActionParamBuilder(
      {required super.index,
      required super.defualtWidth,
      required this.rowIndex});
}

/// A widget that displays an advanced table with customizable headers, rows, and actions
class AdvancedTableWidget extends StatelessWidget {
  /// List of actions to be displayed for each row
  final List? actions;

  /// Builder function for creating action widgets
  final Widget Function(BuildContext, ActionParamBuilder)? actionBuilder;

  /// List of header items to be displayed
  final List headerItems;

  /// Builder function for creating header widgets
  final Widget Function(BuildContext, HeaderBuilder) headerBuilder;

  /// Builder function for creating row elements
  final List<Widget> Function(BuildContext, RowBuilderParams)
      rowElementsBuilder;

  /// List of items to be displayed in the table
  final List items;

  /// Notifier for tracking loading state of the entire table
  final ValueNotifier<bool> isLoadingAll;

  /// Notifier for tracking loading state of additional items
  final ValueNotifier<bool>? isLoadingMore;

  /// Widget to display when the table is empty
  final Widget? onEmptyState;

  /// Decoration for the header section
  final BoxDecoration? headerDecoration;

  /// Padding inside the header
  final EdgeInsets? innerHeaderPadding;

  /// Padding for table elements
  final EdgeInsets? elementsPadding;

  /// Widget to display when the entire table is loading
  final Widget fullLoadingPlaceHolder;

  /// Widget to display when loading more items
  final Widget? loadingMorePlaceHolder;

  /// Decoration for row elements
  final BoxDecoration? rowElementsDecoration;

  /// Padding inside row elements
  final EdgeInsets? innerRowElementsPadding;

  /// Text style for header text
  final TextStyle? headerTextStyle;

  /// Padding outside the rows
  final EdgeInsets? outterRowsPadding;

  /// Builder function for row decorations based on index
  /// and whether the row is hovered
  final BoxDecoration Function(int, bool)? rowDecorationBuilder;

  /// Padding outside the header
  final EdgeInsets? outterHeaderPadding;

  /// Whether to add a spacer before actions
  final bool addSpacerToActions;

  /// Callback function when a row is tapped
  final void Function(int)? onRowTap;

  /// the builder of the row for more controle of the row, for example you can add animations on x row or all rows
  /// you get the  index of the row and the row itself
  /// and the is hover
  final Widget Function(BuildContext, int, Widget, bool)? rowBuilder;

  /// Creates an [AdvancedTableWidget] instance
  const AdvancedTableWidget({
    super.key,
    required this.headerBuilder,
    required this.rowElementsBuilder,
    required this.items,
    required this.isLoadingAll,
    this.isLoadingMore,
    this.onEmptyState,
    this.headerDecoration,
    this.innerHeaderPadding,
    required this.fullLoadingPlaceHolder,
    this.loadingMorePlaceHolder,
    this.elementsPadding,
    this.rowElementsDecoration,
    this.innerRowElementsPadding,
    this.headerTextStyle,
    this.outterRowsPadding,
    this.rowDecorationBuilder,
    this.outterHeaderPadding,
    required this.headerItems,
    this.actions,
    this.actionBuilder,
    this.addSpacerToActions = true,
    this.onRowTap,
    this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final paddingObjects =
        elementsPadding ?? const EdgeInsets.symmetric(vertical: 5);
    // const EdgeInsets.all(4).add(const EdgeInsets.symmetric(horizontal: 20));
    return ValueListenableBuilder(
        valueListenable: isLoadingAll,
        builder: (context, isLoading, _) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? fullLoadingPlaceHolder
                  : LayoutBuilder(builder: (
                      context,
                      c,
                    ) {
                      final actionsLength = (actions?.length ?? 0);
                      final maxWidth = c.biggest.width;
                      final columnWidth =
                          maxWidth / ((headerItems.length + 1) + actionsLength);

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            DefaultTextStyle(
                              style: Theme.of(context).textTheme.labelMedium!,
                              child: Padding(
                                padding: paddingObjects.add(
                                    outterHeaderPadding ??
                                        const EdgeInsets.only(bottom: 10)),
                                child: Container(
                                  decoration: headerDecoration,
                                  padding: innerHeaderPadding,
                                  child: Row(
                                    children: [
                                      for (int i = 0;
                                          i < headerItems.length;
                                          i++) ...[
                                        headerBuilder(
                                            context,
                                            HeaderBuilder(
                                              value: headerItems[i],
                                              index: i,
                                              defualtWidth: columnWidth,
                                            )),
                                      ],
                                      if (addSpacerToActions) ...[
                                        const Spacer(),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (isLoadingMore != null)
                              ValueListenableBuilder(
                                  valueListenable: isLoadingMore!,
                                  builder: (context, loadingMore, _) {
                                    return AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: Visibility(
                                        visible: loadingMore,
                                        child: Padding(
                                          padding: paddingObjects,
                                          child: loadingMorePlaceHolder ??
                                              LinearProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  }),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: items.isEmpty
                                  ? onEmptyState
                                  : ListView.builder(
                                      padding: outterRowsPadding,
                                      itemBuilder: (context, index) {
                                        final hoverState = ValueNotifier(false);
                                        final rowElements = rowElementsBuilder(
                                            context,
                                            RowBuilderParams(
                                                index: index,
                                                defualtWidth: columnWidth));

                                        return ValueListenableBuilder(
                                            valueListenable: hoverState,
                                            builder: (context, isHover, _) {
                                              final widget =
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          hoverState,
                                                      builder: (context,
                                                          isHover, _) {
                                                        return Padding(
                                                          padding:
                                                              paddingObjects,
                                                          child: InkWell(
                                                            onTap: () =>
                                                                onRowTap?.call(
                                                                    index),
                                                            onHover: (value) {
                                                              hoverState.value =
                                                                  value;
                                                            },
                                                            borderRadius: BorderRadius.all((rowElementsDecoration ??
                                                                    rowDecorationBuilder
                                                                        ?.call(
                                                                            index,
                                                                            isHover) ??
                                                                    const BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))))
                                                                .borderRadius!
                                                                .resolve(null)
                                                                .bottomLeft),
                                                            child:
                                                                AnimatedContainer(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                              decoration: rowElementsDecoration ??
                                                                  rowDecorationBuilder
                                                                      ?.call(
                                                                          index,
                                                                          isHover),
                                                              padding:
                                                                  innerRowElementsPadding,
                                                              child: Builder(
                                                                  builder:
                                                                      (context) {
                                                                final list = [
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          rowElements
                                                                              .length;
                                                                      i++) ...[
                                                                    rowElements[
                                                                        i],
                                                                  ],
                                                                  if (addSpacerToActions) ...[
                                                                    const Spacer(),
                                                                  ],
                                                                  if (actions !=
                                                                      null)
                                                                    for (int i =
                                                                            0;
                                                                        i < actions!.length;
                                                                        i++) ...[
                                                                      actionBuilder!.call(
                                                                          context,
                                                                          ActionParamBuilder(
                                                                              rowIndex: index,
                                                                              index: i,
                                                                              defualtWidth: columnWidth * .5))
                                                                    ]
                                                                ];

                                                                return Row(
                                                                  children:
                                                                      list,
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        );
                                                      });

                                              return rowBuilder?.call(context,
                                                      index, widget, isHover) ??
                                                  widget;
                                            });
                                      },
                                      itemCount: items.length,
                                    ),
                            )),
                          ],
                        ),
                      );
                    }));
        });
  }
}

/// A class that extends [RowBuilderParams] to provide parameters for header builders
class HeaderBuilder extends RowBuilderParams {
  /// The value of the header
  final dynamic value;

  /// Creates a [HeaderBuilder] instance
  HeaderBuilder(
      {required this.value, required super.index, required super.defualtWidth});
}

/// A class that provides basic parameters for row builders
class RowBuilderParams {
  /// The index of the row or element
  final int index;

  /// The default width for the element
  final double defualtWidth;

  /// Creates a [RowBuilderParams] instance
  RowBuilderParams({required this.index, required this.defualtWidth});
}
