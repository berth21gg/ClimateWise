import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.color,
    required this.onTapExit,
    required this.onTapProfile,
  });

  final Color color;
  final VoidCallback onTapExit;
  final VoidCallback onTapProfile;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.rotate(
              angle: 180 * math.pi / 180,
              child: IconButton(
                onPressed: onTapExit,
                icon: const Icon(
                  Icons.exit_to_app_outlined,
                  size: 30,
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                          ),
                          child: Center(
                            child: Container(
                              height: 5,
                              width: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onTapProfile,
              icon: const Icon(
                Icons.person_outline_outlined,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
