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
