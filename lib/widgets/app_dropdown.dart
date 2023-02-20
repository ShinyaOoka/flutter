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
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        readOnly
            ? TextFormField(
                style: TextStyle(color: Theme.of(context).primaryColor),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: label != null ? Text(label!) : null,
                  border: const OutlineInputBorder(),
                  counterText: ' ',
                  counterStyle: const TextStyle(height: 0.2, fontSize: 10),
                ),
                readOnly: readOnly,
                enabled: enabled,
                controller: TextEditingController(
                    text: itemAsString != null && selectedItem != null
                        ? itemAsString!(selectedItem as T)
                        : selectedItem != null
                            ? selectedItem.toString()
                            : ''),
              )
            : DropdownSearch<T>(
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
                        counterStyle:
                            const TextStyle(height: 0.2, fontSize: 10))),
                onChanged: onChanged ?? (_) {},
                compareFn: compareFn,
                selectedItem: selectedItem,
                enabled: enabled,
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
    this.enabled = true,
    this.readOnly = false,
  });
}
