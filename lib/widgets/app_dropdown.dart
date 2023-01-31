import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<T>? items;
  final String? label;
  final String Function(T)? itemAsString;
  final void Function(T?)? onChanged;
  final bool Function(T, T)? compareFn;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<T>(
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder())),
            // showSelectedItems: true,
            scrollbarProps: ScrollbarProps(thumbVisibility: true),
          ),
          items: items ?? [],
          itemAsString: itemAsString,
          clearButtonProps: const ClearButtonProps(isVisible: true),
          dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: TextStyle(color: Theme.of(context).primaryColor),
              dropdownSearchDecoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: label,
                  border: const OutlineInputBorder(),
                  counterText: ' ',
                  counterStyle: const TextStyle(height: 0.5, fontSize: 12))),
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
  });
}
