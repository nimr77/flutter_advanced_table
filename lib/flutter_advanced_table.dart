import 'package:flutter/material.dart';

/// A class that extends [RowBuilderParams] to provide parameters for action builders
/// This class is used to pass additional information to the `actionBuilder` function.
class ActionParamBuilder extends RowBuilderParams {
  /// The index of the row in the table.  Useful for identifying which row the action belongs to.
  final int rowIndex;

  /// Creates an [ActionParamBuilder] instance.
  /// [index]: The index of the action within the `actions` list.
  /// [defualtWidth]:  The default width for the action widget.
  /// [rowIndex]: The index of the row.
  ActionParamBuilder(
      {required super.index,
      required super.defualtWidth,
      required this.rowIndex});
}

/// A widget that displays an advanced table with customizable headers, rows, and actions.
/// This is the main widget you'll use to create your table.
class AdvancedTableWidget extends StatelessWidget {
  /// List of actions to be displayed for each row.  This is primarily used for *calculating widths*
  /// and determining how many action widgets to create.  The actual widgets are built by `actionBuilder`.
  final List? actions;

  /// Builder function for creating action widgets.
  /// This function is called for each action defined in `actions`.
  /// It receives the [BuildContext] and an [ActionParamBuilder] object.
  final Widget Function(BuildContext, ActionParamBuilder)? actionBuilder;

  /// List of header items to be displayed.  This is a simple list of data (usually Strings)
  /// that represent the header text for each column.
  final List headerItems;

  /// Builder function for creating header widgets.
  /// This function is called for each item in `headerItems`.
  /// It receives the [BuildContext] and a [HeaderBuilder] object.
  final Widget Function(BuildContext, HeaderBuilder) headerBuilder;

  /// Builder function for creating the row elements (the cells within each row).
  /// This function is called for each item in `items`.
  /// It receives the [BuildContext] and a [RowBuilderParams] object, and returns a *list* of Widgets,
  /// one for each column in the row (excluding actions).
  final List<Widget> Function(BuildContext, RowBuilderParams)
      rowElementsBuilder;

  /// List of items (your data) to be displayed in the table.  This is your main data source.
  /// Each item in this list corresponds to a row in the table.
  final List items;

  /// Notifier for tracking the loading state of the entire table.
  /// When `true`, the `fullLoadingPlaceHolder` is displayed.
  final ValueNotifier<bool> isLoadingAll;

  /// Notifier for tracking the loading state of additional items (e.g., for pagination).
  /// When `true`, the `loadingMorePlaceHolder` is displayed.
  final ValueNotifier<bool>? isLoadingMore;

  /// Widget to display when the table is empty (i.e., `items` is empty).
  final Widget? onEmptyState;

  /// Decoration for the header section (the entire header row).
  final BoxDecoration? headerDecoration;

  /// Padding inside the header (around the header cells).
  final EdgeInsets? innerHeaderPadding;

  /// Padding for table elements (around the entire table content).
  final EdgeInsets? elementsPadding;

  /// Widget to display when the entire table is loading (`isLoadingAll` is true).
  final Widget fullLoadingPlaceHolder;

  /// Widget to display when loading more items (`isLoadingMore` is true).
  final Widget? loadingMorePlaceHolder;

  /// Decoration for the row elements (applied to each row).
  final BoxDecoration? rowElementsDecoration;

  /// Padding inside the row elements (around the cells within each row).
  final EdgeInsets? innerRowElementsPadding;

  /// Text style for the header text.
  final TextStyle? headerTextStyle;

  /// Padding outside the rows (around the entire list of rows).
  final EdgeInsets? outterRowsPadding;

  /// Builder function for row decorations.
  /// This function is called for each row and allows you to dynamically style the row
  /// based on its index and whether it's being hovered over.
  final BoxDecoration Function(int, bool)? rowDecorationBuilder;

  /// Padding outside the header (above the header row).
  final EdgeInsets? outterHeaderPadding;

  /// Whether to add a spacer before the action buttons.  This can improve visual separation.
  final bool addSpacerToActions;

  /// Callback function when a row is tapped.
  /// The `int` parameter is the index of the tapped row.
  final void Function(int)? onRowTap;

  /// the builder of the row for more controle of the row, for example you can add animations on x row or all rows
  /// you get the  index of the row and the row itself
  /// and the is hover
  /// this builder overwrite the internal builder
  final Widget Function(BuildContext, int, Widget, bool)? rowBuilder;

  /// Creates an [AdvancedTableWidget] instance.
  /// All the parameters are explained above.  The `required` keyword indicates mandatory parameters.
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
    this.addSpacerToActions = true, // Default value
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

/// A class that extends [RowBuilderParams] to provide parameters for header builders.
/// Used to pass information to the `headerBuilder` function.
class HeaderBuilder extends RowBuilderParams {
  /// The value of the header (typically a String).  This is the data that will be displayed in the header cell.
  final dynamic value;

  /// Creates a [HeaderBuilder] instance.
  /// [value]: The data for the header cell.
  /// [index]: The index of the header (column index).
  /// [defualtWidth]: The default width for the header cell.
  HeaderBuilder(
      {required this.value, required super.index, required super.defualtWidth});
}

/// A class that provides basic parameters for row builders.
/// A base class, extended by [ActionParamBuilder] and [HeaderBuilder].
class RowBuilderParams {
  /// The index of the row or element.
  final int index;

  /// The default width for the element.
  final double defualtWidth;

  /// Creates a [RowBuilderParams] instance.
  /// [index]:  The index of the row or element.
  /// [defualtWidth]: The calculated default width for this element.
  RowBuilderParams({required this.index, required this.defualtWidth});
}
