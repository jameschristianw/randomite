import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final String title;
  final bool isLast;
  final int index;
  final Function onEditHandler, onDeleteHandler;
  const ItemList({
    Key? key,
    required this.title,
    this.isLast = false,
    required this.index,
    required this.onDeleteHandler,
    required this.onEditHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const marginSize = 12.0;

    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.only(
          top: marginSize,
          left: marginSize,
          right: marginSize,
          bottom: isLast ? marginSize : 0,
        ),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Row(
                children: [
                  IconButton(
                    onPressed: () => onEditHandler(title, index),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: "Ubah $title",
                  ),
                  IconButton(
                    onPressed: () => onDeleteHandler(title, index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus $title',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
