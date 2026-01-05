import 'package:flutter/material.dart';
import 'package:moto_tracking_flutter/src/theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final String activeMenu;
  final void Function(String id) onMenuClick;

  const BottomNav({
    super.key,
    required this.activeMenu,
    required this.onMenuClick,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem('feed', Icons.home_outlined, 'Feed'),
      _NavItem('avisos', Icons.notifications_none, 'Avisos'),
      _NavItem('chat', Icons.chat_bubble_outline, 'Chat'),
      _NavItem('eventos', Icons.calendar_month_outlined, 'Eventos'),
      _NavItem('more', Icons.more_horiz, 'Mais'),
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0x11000000))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((it) {
            final selected = activeMenu == it.id;
            final color = selected ? AppTheme.primary : AppTheme.textDark;
            return InkWell(
              onTap: () => onMenuClick(it.id),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(it.icon, color: color, size: 24),
                    const SizedBox(height: 2),
                    Text(
                      it.label,
                      style: TextStyle(fontSize: 11, color: color),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final String label;
  _NavItem(this.id, this.icon, this.label);
}
