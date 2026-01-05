import 'package:flutter/material.dart';
import 'package:moto_tracking_flutter/src/theme/app_theme.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Center(
            child: Text(
              'MT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Moto Tracking',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
