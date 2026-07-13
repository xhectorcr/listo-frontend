import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/app_button.dart';
import 'landing_page_styles.dart';
import 'landing_page_widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LandingStyles.scaffoldBackground,
      extendBodyBehindAppBar: true,

      // =========================
      // NAVBAR
      // =========================
      appBar: AppBar(
        toolbarHeight: 85,
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.75),
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: LandingStyles.navbarBlurBorderDecoration,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: LandingStyles.navbarLogoDecoration,
                child: Text(
                  "L!",
                  style: LandingStyles.logoTextStyle,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                "LISTO! GO",
                style: LandingStyles.brandTextStyle,
              ),
              const Spacer(),
              AppButton(
                text: "Iniciar sesión",
                type: AppButtonType.text,
                isFullWidth: false,
                onPressed: () {
                  context.go('/login');
                },
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            _heroSection(context),
            _howItWorksSection(),
            _productsSection(),
            _discountSection(context),
            _statsSection(),
            _mobileAppSection(context),
            _footer(),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // HERO SECTION RESPONSIVE
  // =====================================================

  Widget _heroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final mobile = width < 950;

    return Container(
      width: double.infinity,

      // ALTURA MINIMA
      constraints: BoxConstraints(minHeight: size.height),

      padding: EdgeInsets.only(
        top: mobile ? 110 : 120,
        left: mobile ? 20 : 60,
        right: mobile ? 20 : 60,
        bottom: mobile ? 40 : 50,
      ),

      decoration: LandingStyles.heroBackgroundDecoration,

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1450),

          child: Flex(
            direction: mobile ? Axis.vertical : Axis.horizontal,

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // =====================================================
              // TEXTO
              // =====================================================
              Expanded(
                flex: 5,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: mobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,

                  children: [
                    // BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: LandingStyles.heroBadgeDecoration,
                      child: Text(
                        "SMART SHOPPING EXPERIENCE",
                        style: LandingStyles.heroBadgeTextStyle,
                      ),
                    ),

                    SizedBox(height: mobile ? 20 : 28),

                    // TITULO
                    Text(
                      "El futuro de las compras ya está aquí",
                      textAlign: mobile ? TextAlign.center : TextAlign.left,
                      style: mobile 
                          ? LandingStyles.heroTitleMobileStyle 
                          : LandingStyles.heroTitleDesktopStyle,
                    ),

                    SizedBox(height: mobile ? 18 : 25),

                    // DESCRIPCION
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650),
                      child: Text(
                        "Compra sin filas, sin cajeros y sin esperas. "
                        "Solo entra, toma tus productos y sal automáticamente.",
                        textAlign: mobile ? TextAlign.center : TextAlign.left,
                        style: mobile 
                            ? LandingStyles.heroDescMobileStyle 
                            : LandingStyles.heroDescDesktopStyle,
                      ),
                    ),

                    SizedBox(height: mobile ? 28 : 38),

                    // BOTON
                    AppButton(
                      text: "Iniciar sesión",
                      isFullWidth: mobile,
                      onPressed: () {
                        context.go('/login');
                      },
                    ),

                    SizedBox(height: mobile ? 30 : 45),

                    // =====================================================
                    // STATS
                    // =====================================================
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: mobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: const [
                        HeroStat(value: "99.8%", label: "Precisión IA"),
                        HeroStat(value: "+10K", label: "Productos detectados"),
                        HeroStat(value: "24/7", label: "Automatización"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: mobile ? 0 : 60, height: mobile ? 40 : 0),

              // =====================================================
              // IMAGEN
              // =====================================================
              Expanded(
                flex: 5,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // FONDO DIFUMINADO
                      Container(
                        width: mobile ? 320 : 560,
                        height: mobile ? 320 : 560,
                        decoration: LandingStyles.heroImageBackgroundDecoration,
                      ),

                      // IMAGEN
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          "assets/image/landing-1.webp",
                          width: mobile ? 330 : 620,
                          height: mobile ? 330 : 500,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: mobile ? 330 : 620,
                              height: mobile ? 330 : 500,
                              decoration: LandingStyles.heroImageFallbackDecoration,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.broken_image_rounded,
                                    size: 80,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "No se pudo cargar la imagen",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // HOW IT WORKS
  // =====================================================

  Widget _howItWorksSection() {
    return SectionWrapper(
      title: "¿Cómo funciona?",
      subtitle: "Comprar nunca fue tan simple.",
      dark: true,
      child: Wrap(
        spacing: 25,
        runSpacing: 25,
        alignment: WrapAlignment.center,
        children: const [
          StepCard(
            step: "1", 
            title: "Regístrate y Recarga",
            description: "Crea tu cuenta aquí y recarga tu tarjeta virtual", 
            icon: Icons.account_balance_wallet,
          ),
          StepCard(
            step: "2", 
            title: "Genera tu PIN",
            description: "Presiona Inicio en tu app e ingresa el código en la pantalla exterior", 
            icon: Icons.pin,
          ),
          StepCard(
            step: "3", 
            title: "Elige tus productos",
            description: "Entra a la tienda y selecciona lo que deseas llevar", 
            icon: Icons.shopping_bag,
          ),
          StepCard(
            step: "4", 
            title: "Paga y Listo",
            description: "Confirma el pago en la pantalla y retírate sin hacer filas", 
            icon: Icons.exit_to_app,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PRODUCTS
  // =====================================================

  Widget _productsSection() {
    return SectionWrapper(
      title: "Productos destacados",
      subtitle: "Encuentra tus productos favoritos al instante.",
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: const [
          ProductCard(title: "Coca Cola", price: "S/ 3.50", imagePath: "assets/image/coca-cola.webp"),
          ProductCard(title: "Inca Kola", price: "S/ 3.50", imagePath: "assets/image/inka-cola.webp"),
          ProductCard(title: "Papas Lays", price: "S/ 2.50", imagePath: "assets/image/papas-lays.jpg"),
          ProductCard(title: "Oreo", price: "S/ 1.20", imagePath: "assets/image/oreo.jpg"),
          ProductCard(title: "Agua San Luis", price: "S/ 2.00", imagePath: "assets/image/agua-sanluis.jpg"),
          ProductCard(title: "Snickers", price: "S/ 3.00", imagePath: "assets/image/snickers.png"),
        ],
      ),
    );
  }

  // =====================================================
  // DISCOUNTS
  // =====================================================

  Widget _discountSection(BuildContext context) {
    return SectionWrapper(
      title: "Ofertas y descuentos",
      subtitle: "Promociones automáticas impulsadas por IA.",
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: const [
          DiscountCard(title: "2x1 en gaseosas", desc: "Solo por hoy"),
          DiscountCard(title: "Combo snacks", desc: "Ahorra hasta 30%"),
          DiscountCard(title: "Happy Hour", desc: "Descuentos nocturnos"),
        ],
      ),
    );
  }

  // =====================================================
  // STATS
  // =====================================================

  Widget _statsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      child: Wrap(
        spacing: 60,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: const [
          BigStat(value: "10K+", label: "Compras registradas"),
          BigStat(value: "99.8%", label: "Precisión IA"),
          BigStat(value: "-80%", label: "Tiempo en filas"),
          BigStat(value: "24/7", label: "Monitoreo"),
        ],
      ),
    );
  }

  // =====================================================
  // MOBILE APP
  // =====================================================

  Widget _mobileAppSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mobile = width < 900;

    return SectionWrapper(
      title: "Controla todo desde tu app",
      subtitle: "Gestiona promociones, historial y accesos desde tu celular.",
      child: Flex(
        direction: mobile ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(
            child: Image.asset(
              "assets/image/mobile_app.png",
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 40, height: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: Icon(Icons.qr_code),
                  title: Text("QR de acceso"),
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Historial de compras"),
                ),
                ListTile(
                  leading: Icon(Icons.discount),
                  title: Text("Promociones exclusivas"),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text("Billetera virtual"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // FOOTER
  // =====================================================

  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(50),
      color: LandingStyles.darkBackground,
      child: Column(
        children: [
          Text(
            "LISTO! GO",
            style: LandingStyles.footerLogoStyle,
          ),
          const SizedBox(height: 20),
          Text(
            "Compras inteligentes impulsadas por IA.",
            style: LandingStyles.footerSubtitleStyle,
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 25,
            children: const [
              FooterItem(title: "Soporte"),
              FooterItem(title: "Privacidad"),
              FooterItem(title: "Términos"),
              FooterItem(title: "Contacto"),
            ],
          ),
        ],
      ),
    );
  }
}
