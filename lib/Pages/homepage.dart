import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Feed',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: -0.3),
        ),
      

      actions : [ IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search, color: Colors.white, size: 22),
        style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.1), shape: const CircleBorder()),
      ),

      Padding(
        padding: const EdgeInsets.only(right: 14, left: 4),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7F77DD), Color(0xFFD4537E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: const Text(
              'M',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ]
  ),

  body: Container(),
  );
  }
}

