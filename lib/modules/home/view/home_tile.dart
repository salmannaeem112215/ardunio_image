import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.image,
    required this.text,
    this.onTap,
    this.color = Colors.blue,
    this.label = '',
    this.iconWidth = 100,
    this.widget,
  });
  final String image;
  final String text;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double iconWidth;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            image,
            width: iconWidth,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 17),
                ),
                const SizedBox(height: 10),
                widget == null
                    ? ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12)),
                        child: Text(label),
                      )
                    : widget!,
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
    ]);
  }
}
