import 'package:flutter/material.dart';
import 'package:randomite/constants/prefs_constants.dart';
import 'package:randomite/widgets/item_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final SharedPreferences prefs;
  const Homepage({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ItemCategory(
              prefs: widget.prefs,
              sharedConstant: PrefsConstants.restaurantData,
              title: 'Makan apa yaa',
              icon: Icons.local_restaurant,
            ),
            ItemCategory(
              prefs: widget.prefs,
              sharedConstant: PrefsConstants.cafeData,
              title: 'Yang manis manis',
              icon: Icons.local_drink_rounded,
            )
          ],
        ),
      ),
    );
  }
}
