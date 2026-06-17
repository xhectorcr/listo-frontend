import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:html' as html;
import 'landing_page_styles.dart';

class SectionWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool dark;

  const SectionWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      color: dark ? LandingStyles.darkBackground : Colors.white,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: dark 
                ? LandingStyles.sectionTitleDarkStyle 
                : LandingStyles.sectionTitleLightStyle,
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: dark 
                ? LandingStyles.sectionSubtitleDarkStyle 
                : LandingStyles.sectionSubtitleLightStyle,
          ),
          const SizedBox(height: 60),
          child,
        ],
      ),
    );
  }
}

class BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const BenefitCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(28),
      decoration: LandingStyles.benefitCardDecoration,
      child: Column(
        children: [
          Icon(icon, size: 45, color: LandingStyles.primaryColor),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: LandingStyles.benefitCardTitleStyle,
          ),
        ],
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final IconData icon;

  const StepCard({
    super.key,
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(28),
      decoration: LandingStyles.stepCardDecoration,
      child: Column(
        children: [
          Text(
            step,
            style: LandingStyles.stepCardStepStyle,
          ),
          const SizedBox(height: 20),
          Icon(icon, color: Colors.white, size: 42),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: LandingStyles.stepCardTitleStyle,
          ),
          const SizedBox(height: 10),
          description == "Crea tu cuenta aquí y recarga tu tarjeta virtual"
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: LandingStyles.stepCardRichDescStyle,
                    children: [
                      const TextSpan(text: "Crea tu cuenta "),
                      TextSpan(
                        text: "aquí",
                        style: LandingStyles.stepCardLinkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            html.window.location.hash = '/login';
                          },
                      ),
                      const TextSpan(text: " y recarga tu tarjeta virtual"),
                    ],
                  ),
                )
              : Text(
                  description,
                  textAlign: TextAlign.center,
                  style: LandingStyles.stepCardDescStyle,
                ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: LandingStyles.productCardDecoration,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              imagePath,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: LandingStyles.productCardTitleStyle,
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: LandingStyles.productCardPriceStyle,
          ),
        ],
      ),
    );
  }
}

class DiscountCard extends StatelessWidget {
  final String title;
  final String desc;

  const DiscountCard({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(35),
      decoration: LandingStyles.discountCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 25),
          Text(
            title,
            style: LandingStyles.discountCardTitleStyle,
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            style: LandingStyles.discountCardDescStyle,
          ),
        ],
      ),
    );
  }
}

class TechChip extends StatelessWidget {
  final String title;

  const TechChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: LandingStyles.techChipDecoration,
      child: Text(
        title,
        style: LandingStyles.techChipStyle,
      ),
    );
  }
}

class BigStat extends StatelessWidget {
  final String value;
  final String label;

  const BigStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: LandingStyles.bigStatValueStyle,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: LandingStyles.bigStatLabelStyle,
        ),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  final String city;

  const LocationCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(35),
      decoration: LandingStyles.locationCardDecoration,
      child: Column(
        children: [
          const Icon(Icons.location_on, color: LandingStyles.primaryColor, size: 42),
          const SizedBox(height: 20),
          Text(
            city,
            style: LandingStyles.locationCardCityStyle,
          ),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: LandingStyles.statItemValueStyle,
        ),
        const SizedBox(height: 5),
        Text(
          label, 
          style: LandingStyles.statItemLabelStyle,
        ),
      ],
    );
  }
}

class FooterItem extends StatelessWidget {
  final String title;

  const FooterItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title, 
      style: LandingStyles.footerItemStyle,
    );
  }
}

class HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const HeroStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: LandingStyles.heroStatDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: LandingStyles.heroStatValueStyle,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: LandingStyles.heroStatLabelStyle,
          ),
        ],
      ),
    );
  }
}
