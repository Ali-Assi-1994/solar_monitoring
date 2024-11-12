import 'package:flutter/material.dart';

class RetryWidget extends StatelessWidget {
  final Function retryFunction;
  final double height;

  const RetryWidget({super.key, required this.retryFunction, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(11),
          fixedSize: WidgetStateProperty.all(const Size.fromHeight(12)),
          backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
          shape: WidgetStateProperty.all(
            ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () => retryFunction(),
        child: Text(
          "Retry",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
        ),
      ),
    );
  }
}
