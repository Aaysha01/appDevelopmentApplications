import 'package:flutter/material.dart';

class wisdom extends StatefulWidget {
  const wisdom({Key? key}) : super(key: key);

  @override
  State<wisdom> createState() => _wisdomState();
}

class _wisdomState extends State<wisdom> {
  int _index = 0;
  List quotes = [
    "wwwwwwwwwwwwwwwwwwwwwww",
    "aaaaaaaaaaaaaaaaaaaaaaaa",
    "Keep smiling, because life is a beautiful thing and there's so much to smile about.",
    "Life is a long lesson in humility. - ...",
    "In three words I can sum up everything I've learned about life: it goes on. - ...",
    "Love the life you live. ...",
    "Life is either a daring adventure or nothing at all"
  ];
  void _showQoutes() {
    setState(() {
      _index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Container(
                      width: 350,
                      height: 200,
                      margin: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade700,
                        borderRadius: BorderRadius.circular(14.5),

                      ),
                      child: Center(
                          child: Text(quotes[_index % quotes.length]))),
                ),
                Divider(
                  thickness: 4.3,
                ),
                ElevatedButton.icon(
                  onPressed: _showQoutes,
                  icon: Icon(Icons.wb_sunny),
                  label: Text("Inspireme!",
                      style: TextStyle(color: Colors.white, fontSize: 18.8)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Text("created by Name Roll Batch ANd style ",style: TextStyle(color: Colors.red, fontSize: 18.8)),
                ),
                Spacer(        flex: 4,        ),
              ],
            )));

  }



}