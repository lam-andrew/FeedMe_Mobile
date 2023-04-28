import 'package:flutter/material.dart';

class FlashMessageScreen extends StatelessWidget{
  const FlashMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: FlashMessage(messageText1: "Oh No!", messageText2: "That Email Address is already in use! Please try again with a different one.", givenColor: Color(0xFFC72C41)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          },
          child: const Text("Show Message"),
        ),
      ),
    );
  }

}

// FreshMessage cards created here for ScaffoldMessenger and SnackBar in log-in and sign-up success and error messages
class FlashMessage extends StatelessWidget {
  const FlashMessage({
    super.key, required this.messageText1, required this.messageText2, required this.givenColor,
  });

  final String messageText1;
  final String messageText2;
  final Color givenColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
            color: givenColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageText1,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      messageText2,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  } // end build
} // end FlashMessage