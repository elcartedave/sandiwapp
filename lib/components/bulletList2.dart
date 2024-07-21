import 'package:flutter/material.dart';

class BulletList2 extends StatelessWidget {
  final List<List<String>> strings;

  BulletList2(this.strings);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((pair) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.55,
                        ),
                        children: [
                          TextSpan(
                            text: pair[0], // Bold text
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: pair[1], // Normal text
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
