import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final List<String>? breadcrumbs;

  const AppLayout({
    super.key,
    required this.child,
    this.breadcrumbs,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String activeItem = 'Início';

  final List<_NavItem> navItems = [
    _NavItem(label: 'Início', icon: Icons.home, route: '/dashboard'),
    _NavItem(label: 'Consultas', icon: Icons.calendar_month, route: '/appointment'),
    _NavItem(label: 'Configurações', icon: Icons.settings, route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawer: _buildSidebar(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: _buildBreadcrumbs(),
      ),
      body: widget.child,
      backgroundColor: const Color(0xFFF5F5F7),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      width: 260,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: const AssetImage('assets/velan-logo.png'),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Velan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: navItems.map((item) {
                final isActive = item.label == activeItem;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isActive ? const Color(0xFF6B5FD1) : Colors.black54,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? const Color(0xFF6B5FD1) : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      activeItem = item.label;
                    });
                    Navigator.of(context).pushNamed(item.route);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Meu Perfil',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    final crumbs = widget.breadcrumbs ?? [];

    if (crumbs.isEmpty) {
      return const SizedBox();
    }

    return Row(
      children: [
        for (int i = 0; i < crumbs.length; i++) ...[
          Text(
            crumbs[i],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          if (i < crumbs.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right, size: 18),
            )
        ]
      ],
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
