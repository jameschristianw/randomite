import 'dart:math';

import 'package:flutter/material.dart';
import 'package:randomite/pages/listpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCategory extends StatelessWidget {
  final SharedPreferences prefs;
  final String title;
  final String sharedConstant;
  final IconData icon;

  const ItemCategory({
    Key? key,
    required this.prefs,
    required this.title,
    required this.sharedConstant,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
      child: ElevatedButton(
        onPressed: () {
          List<String> result = prefs.getStringList(sharedConstant) ?? [];

          if (result.isEmpty) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Belum ada data nih untuk kategori ',
                      ),
                      TextSpan(
                        text: title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                content: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(
                        text: 'Masukkin dulu ya data ',
                      ),
                      TextSpan(
                        text: title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: ' untuk dapat mengacak kategori !',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Oke'),
                  )
                ],
              ),
            );
          } else if (result.length == 1) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Data ',
                      ),
                      TextSpan(
                        text: title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text: ' kurang nih!',
                      ),
                    ],
                  ),
                ),
                content: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(
                        text: 'Sekarang ini cuma ada ',
                      ),
                      TextSpan(
                        text: result[0],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                        text:
                            ' di daftar kamu. Tambahin lagi ya supaya bisa diacak!',
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Oke'),
                  )
                ],
              ),
            );
          } else {
            Random randomGenerator = Random();
            int randomIndex = randomGenerator.nextInt(result.length);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: Wrap(
                  children: [
                    AlertDialog(
                      title: const Center(
                        child: Text('Restoran Terpilih Adalah:'),
                      ),
                      content: Text(
                        result.elementAt(randomIndex),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Oke'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Colors.amber,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(icon),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Listpage(
                          sharedConstant: sharedConstant,
                          title: title,
                        ),
                      ),
                    );
                  },
                  tooltip: 'Ubah isi kategori',
                  icon: const Icon(Icons.edit),
                ),
                // TODO : Bikin bisa sembunyiin kategori
                // IconButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Listpage(
                //           sharedConstant: sharedConstant,
                //           title: title,
                //         ),
                //       ),
                //     );
                //   },
                //   tooltip: 'Hapus kategori',
                //   icon: const Icon(
                //     Icons.delete,
                //     color: Colors.red,
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
