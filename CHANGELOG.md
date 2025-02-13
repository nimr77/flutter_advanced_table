## 1.1.3
* **Updated:**  Adding Slivers

## 1.1.2
* **Updated:**  Adding Slivers

## 1.1.1
* **Updated:**  Adding Slivers
  
## 1.1.0
* **Updated:**  Adding Slivers

## 1.0.4
* **Updated:**  Updated the package description.

## 1.0.3
* **Updated:**  Updated the package description.

## 1.0.2
* **Updated:**  Updated the package description.

## 1.0.0

* **Initial Release!**  The Advanced Table Widget for Flutter is now available!
* **Key Features:**
    * **Flexible Table Structure:**
        *   `headerBuilder`:  Create fully custom header widgets using a builder function.
        *   `rowElementsBuilder`: Define the content of each row dynamically with a builder.
        *   `actionBuilder`: Add action buttons (or any widget) to each row.
    * **Loading State Management:**
        *   `isLoadingAll`:  Display a full-screen loading indicator while data is being fetched.
        *   `isLoadingMore`:  Show a "load more" indicator for pagination/infinite scrolling scenarios.
        *   `fullLoadingPlaceHolder`: Customize the full-screen loading widget.
        *   `loadingMorePlaceHolder`: Customize the "load more" loading widget.
    * **Empty State Handling:**
        *   `onEmptyState`:  Display a custom widget when the table has no data.
    * **Extensive Customization:**
        *   `headerDecoration`, `rowElementsDecoration`:  Apply `BoxDecoration` to headers and rows.
        *   `innerHeaderPadding`, `innerRowElementsPadding`, `outterRowsPadding`, `outterHeaderPadding`, `elementsPadding`: Control padding at various levels.
        *   `headerTextStyle`:  Style the header text.
        *   `rowDecorationBuilder`:  Dynamically style rows based on index and hover state.
    * **User Interaction:**
        *   `onRowTap`:  Handle taps on table rows.
        *   `addSpacerToActions`:  Optionally add a spacer before the action buttons.
   * **Animation:**
        *    `rowBuilder` : add any animation you desire
    * **Core Functionality:**
        *  `items`: The list of data objects to display.
        * `headerItems`: Defines header column.
        *   `actions`:  A list representing the actions available for each row (used for width calculations).