import 'package:flutter/material.dart';
import 'package:randomite/widgets/item_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Listpage extends StatefulWidget {
  final String sharedConstant;
  final String title;
  const Listpage({Key? key, required this.sharedConstant, required this.title})
      : super(key: key);

  @override
  _ListpageState createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {
  late SharedPreferences prefs;

  List<String> lists = [];

  Future<List<String>> getDataList() async {
    prefs = await SharedPreferences.getInstance();

    lists = prefs.getStringList(widget.sharedConstant) ?? [];

    return lists;
  }

  void onItemEdit(title, index) async {
    TextEditingController controller = TextEditingController();
    controller.text = title;

    String newName = "";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Ubah nama $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Nama baru',
          ),
          onChanged: (value) {
            setState(() {
              newName = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              lists.replaceRange(index, index + 1, [newName]);
              prefs.setStringList(widget.sharedConstant, lists);

              Navigator.pop(context);
            },
            child: const Text('Ubah'),
          ),
        ],
      ),
    );

    setState(() {});
  }

  void onItemDelete(title, index) {
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
                text: 'Hapus ',
              ),
              TextSpan(
                text: title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ' dari daftar ',
              ),
              TextSpan(
                text: widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: '?',
              ),
            ],
          ),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                    ' harus ditambahkan lagi secara manual jika sudah dihapus',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                lists.removeAt(index);
                prefs.setStringList(widget.sharedConstant, lists);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const marginSize = 12.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar ${widget.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus semua',
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus semua data restoran?'),
                  content: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        const TextSpan(
                          text: 'Semua data ',
                        ),
                        TextSpan(
                          text: widget.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text:
                              ' harus ditambahkan lagi secara manual jika sudah dihapus',
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Batal',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await prefs.remove(widget.sharedConstant);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ).then((value) {
                setState(() {});
              });
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: marginSize,
              right: marginSize,
              left: marginSize,
            ),
            child: Text(
                'Data pada daftar berikut adalah data yang akan digunakan sebagai data random'),
          ),
          FutureBuilder<List<String>>(
            future: getDataList(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Terjadi kesalahan');
              }
              if (snapshot.data!.isNotEmpty) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => ItemList(
                      title: snapshot.data!.elementAt(index),
                      isLast: snapshot.data!.length == index - 1,
                      index: index,
                      onEditHandler: onItemEdit,
                      onDeleteHandler: onItemDelete,
                    ),
                    itemCount: snapshot.data!.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Belum ada data untuk kategori ',
                            ),
                            TextSpan(
                              text: widget.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String newRestaurant = "";

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Tambah nama data baru'),
              content: TextField(
                decoration:
                    const InputDecoration(hintText: 'Masukkan data di sini'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) => setState(() {
                  newRestaurant = value;
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    lists.add(newRestaurant);
                    prefs.setStringList(widget.sharedConstant, lists);
                    Navigator.pop(context);
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
