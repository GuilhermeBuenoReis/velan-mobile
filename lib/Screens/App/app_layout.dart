import 'package:flutter/material.dart';
import 'package:velan_mobile/app_routes.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final List<String>? breadcrumbs;
  final Widget? floatingActionButton;

  const AppLayout({
    super.key,
    required this.child,
    this.breadcrumbs,
    this.floatingActionButton,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String activeItem = 'Consultas';

  final List<_NavItem> navItems = const [
    _NavItem(
      label: 'Consultas',
      icon: Icons.calendar_month,
      route: AppRoutes.appointment,
    ),
    _NavItem(
      label: 'Perfil',
      icon: Icons.person_outline,
      route: AppRoutes.profile,
    ),
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
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: const Color(0xFFF5F5F7),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final bool isProfileActive =
        currentRoute == AppRoutes.profile || activeItem == 'Perfil';

    void goToProfile() {
      Navigator.of(context).pop();
      setState(() => activeItem = 'Perfil');
      if (currentRoute != AppRoutes.profile) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
      }
    }

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
                  backgroundColor: const Color(0xFFE8E7FF),
                  backgroundImage: const AssetImage('assets/velan-logo.png'),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Velan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: navItems.map((item) {
                final isActive =
                    currentRoute == item.route || item.label == activeItem;
                const inactiveColor = Color(0xFF9DA3B4);
                return ListTile(
                  leading: Icon(
                    item.icon,
                    color: isActive ? const Color(0xFF5B4DDC) : inactiveColor,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? const Color(0xFF5B4DDC)
                          : inactiveColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => activeItem = item.label);
                    if (ModalRoute.of(context)?.settings.name != item.route) {
                      Navigator.of(context).pushReplacementNamed(item.route);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      isProfileActive ? const Color(0xFF5B4DDC) : Colors.black12,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: goToProfile,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: isProfileActive
                        ? const Color(0xFF5B4DDC)
                        : const Color(0xFF9DA3B4),
                  ),
                  label: Text(
                    'Meu Perfil',
                    style: TextStyle(
                      fontSize: 14,
                      color: isProfileActive
                          ? const Color(0xFF5B4DDC)
                          : const Color(0xFF9DA3B4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gerencie suas informações.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54.withOpacity(.8),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
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
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          if (i < crumbs.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right, size: 18),
            ),
        ],
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
