import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomDropDown extends StatefulWidget {
  final List<String> items;
  final Text title;
  final String? selectedValue;
  final Function(String) onSelect;

  CustomDropDown({
    required this.items,
    required this.title,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            constraints: BoxConstraints(
              minHeight: 60,
              minWidth: double.infinity,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: widget.title,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDropdownOpen = !isDropdownOpen;
                    });
                  },
                  child: Icon(
                    isDropdownOpen
                        ? Icons.keyboard_double_arrow_up_rounded
                        : Icons.keyboard_double_arrow_down_rounded,
                  ),
                ),
              ],
            ),
          ),
          if (isDropdownOpen)
            Container(
              height: 120,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.items[index],
                        style: TextStyle(color: Colors.grey[800], fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      widget.onSelect(widget.items[index]);
                    },
                    trailing: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.selectedValue == widget.items[index]
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: widget.selectedValue == widget.items[index]
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : Container(),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
