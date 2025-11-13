import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome-how-it-works.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome-testimonials.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_benefits.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_footer.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_hero.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_navbar.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_pricing.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/Widgets/welcome_system_demo.dart';

const double _welcomeNavPadding = 120;

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ScrollController _controller = ScrollController();
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!mounted) return;
    setState(() {
      _offset = _controller.offset;
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0D13),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _controller,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: const [
                    SizedBox(height: _welcomeNavPadding),
                    WelcomeHero(),
                    SizedBox(height: 56),
                    WelcomeHowItWorks(),
                    SizedBox(height: 56),
                    WelcomeBenefits(),
                    SizedBox(height: 56),
                    WelcomeSystemDemo(),
                    SizedBox(height: 56),
                    WelcomeTestimonials(),
                    SizedBox(height: 56),
                    WelcomePricing(),
                    SizedBox(height: 56),
                    WelcomeFooter(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: WelcomeNavbar(scrollOffset: _offset),
            ),
          ],
        ),
      ),
    );
  }
}
