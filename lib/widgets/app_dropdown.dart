import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<T>? items;
  final String? label;
  final String Function(T)? itemAsString;
  final void Function(T?)? onChanged;
  final bool Function(T, T)? compareFn;
  final T? selectedItem;
  final bool Function(T, String)? filterFn;
  final bool showSearchBox;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<T>(
          filterFn: filterFn,
          popupProps: PopupProps.menu(
            showSearchBox: showSearchBox,
            searchFieldProps: const TextFieldProps(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder())),
            // showSelectedItems: true,
            scrollbarProps: const ScrollbarProps(thumbVisibility: true),
            emptyBuilder: (context, searchEntry) => Container(
              height: 70,
              alignment: Alignment.center,
              child: Text("no_data_found".i18n()),
            ),
          ),
          items: items ?? [],
          itemAsString: itemAsString,
          clearButtonProps: const ClearButtonProps(isVisible: true),
          dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  height: 1.4,
                  overflow: TextOverflow.ellipsis),
              dropdownSearchDecoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: label,
                  border: const OutlineInputBorder(),
                  counterText: ' ',
                  counterStyle: const TextStyle(height: 0.4, fontSize: 10))),
          onChanged: onChanged ?? (_) {},
          compareFn: compareFn,
          selectedItem: selectedItem,
        ),
        const SizedBox(height: 6)
      ],
    );
  }

  const AppDropdown({
    super.key,
    this.items,
    this.label,
    this.itemAsString,
    this.onChanged,
    this.selectedItem,
    this.compareFn,
    this.filterFn,
    this.showSearchBox = false,
  });
}
