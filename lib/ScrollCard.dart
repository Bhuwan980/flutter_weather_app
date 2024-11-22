import 'package:flutter/material.dart';

class ScrollCard extends StatefulWidget {
  final String weatherTime;
  final IconData weatherIcon;
  final double weatherTemperature;

  const ScrollCard(
      {super.key,
      required this.weatherIcon,
      required this.weatherTime,
      required this.weatherTemperature});

  @override
  State<ScrollCard> createState() => _ScrollcardState();
}

// weather forecast card
class _ScrollcardState extends State<ScrollCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.weatherTime,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              Icon(
                widget.weatherIcon,
                size: 32,
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${widget.weatherTemperature}'),
            ],
          ),
        ),
      ),
    );
  }
}
