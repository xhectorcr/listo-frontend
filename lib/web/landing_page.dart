import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const Color primaryColor = Color(0xFFFF5A1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "L!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              const Text(
                "LISTO! GO",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Iniciar sesión",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
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

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF4EF)],
        ),
      ),

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

                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Text(
                        "SMART SHOPPING EXPERIENCE",

                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    SizedBox(height: mobile ? 20 : 28),

                    // TITULO
                    Text(
                      "El futuro de las compras ya está aquí",

                      textAlign: mobile ? TextAlign.center : TextAlign.left,

                      style: TextStyle(
                        fontSize: mobile ? 38 : 64,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF111111),
                      ),
                    ),

                    SizedBox(height: mobile ? 18 : 25),

                    // DESCRIPCION
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650),

                      child: Text(
                        "Compra sin filas, sin cajeros y sin esperas. "
                        "Solo entra, toma tus productos y sal automáticamente.",

                        textAlign: mobile ? TextAlign.center : TextAlign.left,

                        style: TextStyle(
                          fontSize: mobile ? 16 : 18,
                          height: 1.7,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    SizedBox(height: mobile ? 28 : 38),

                    // BOTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 22,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Iniciar sesión",

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

                      children: [
                        _heroStat("99.8%", "Precisión IA"),
                        _heroStat("+10K", "Productos detectados"),
                        _heroStat("24/7", "Automatización"),
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

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: RadialGradient(
                            colors: [
                              primaryColor.withOpacity(0.15),
                              primaryColor.withOpacity(0.02),
                            ],
                          ),
                        ),
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

                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(35),
                              ),

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
  // HERO STATS
  // =====================================================

  Widget _heroStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            value,

            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111111),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HOW IT WORKS
  // =====================================================

  Widget _howItWorksSection() {
    return _sectionWrapper(
      title: "¿Cómo funciona?",
      subtitle: "Comprar nunca fue tan simple.",
      dark: true,
      child: Wrap(
        spacing: 25,
        runSpacing: 25,
        alignment: WrapAlignment.center,
        children: [
          _stepCard("1", "Escanea QR", Icons.qr_code_scanner),
          _stepCard("2", "Entra a tienda", Icons.store),
          _stepCard("3", "Toma productos", Icons.shopping_bag),
          _stepCard("4", "Sal automáticamente", Icons.exit_to_app),
        ],
      ),
    );
  }

  // =====================================================
  // PRODUCTS
  // =====================================================

  Widget _productsSection() {
    return _sectionWrapper(
      title: "Productos destacados",
      subtitle: "Encuentra tus productos favoritos al instante.",
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: [
          _productCard("Coca Cola", "S/ 3.50"),
          _productCard("Inca Kola", "S/ 3.50"),
          _productCard("Papas Lays", "S/ 2.50"),
          _productCard("Oreo", "S/ 1.20"),
          _productCard("Agua San Luis", "S/ 2.00"),
          _productCard("Snickers", "S/ 3.00"),
        ],
      ),
    );
  }

  // =====================================================
  // DISCOUNTS
  // =====================================================

  Widget _discountSection(BuildContext context) {
    return _sectionWrapper(
      title: "Ofertas y descuentos",
      subtitle: "Promociones automáticas impulsadas por IA.",
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: [
          _discountCard("2x1 en gaseosas", "Solo por hoy"),
          _discountCard("Combo snacks", "Ahorra hasta 30%"),
          _discountCard("Happy Hour", "Descuentos nocturnos"),
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
        children: [
          _bigStat("10K+", "Compras registradas"),
          _bigStat("99.8%", "Precisión IA"),
          _bigStat("-80%", "Tiempo en filas"),
          _bigStat("24/7", "Monitoreo"),
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

    return _sectionWrapper(
      title: "Controla todo desde tu app",
      subtitle: "Gestiona promociones, historial y accesos desde tu celular.",
      child: Flex(
        direction: mobile ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(
            child: Image.asset(
              "assets/cocainca.jpg",
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
      color: Colors.black,
      child: Column(
        children: [
          const Text(
            "LISTO! GO",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Compras inteligentes impulsadas por IA.",
            style: TextStyle(color: Colors.grey.shade500),
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 25,
            children: [
              _footerItem("Soporte"),
              _footerItem("Privacidad"),
              _footerItem("Términos"),
              _footerItem("Contacto"),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // COMPONENTS
  // =====================================================

  Widget _sectionWrapper({
    required String title,
    required String subtitle,
    required Widget child,
    bool dark = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      color: dark ? const Color(0xFF111111) : Colors.white,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? Colors.white : Colors.black,
              fontSize: 42,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? Colors.grey.shade400 : Colors.grey.shade700,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 60),

          child,
        ],
      ),
    );
  }

  Widget _benefitCard(IconData icon, String title) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 45, color: primaryColor),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(String step, String title, IconData icon) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            step,
            style: TextStyle(
              color: primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 20),

          Icon(icon, color: Colors.white, size: 42),

          const SizedBox(height: 20),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(String title, String price) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              "assets/cocainca.jpg",
              height: 160,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          const SizedBox(height: 10),

          Text(
            price,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _discountCard(String title, String desc) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5A1F), Color(0xFFFF7A1F)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 15),

          Text(desc, style: const TextStyle(color: Colors.white, fontSize: 17)),
        ],
      ),
    );
  }

  Widget _techChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _bigStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 52,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
        ),
      ],
    );
  }

  Widget _locationCard(String city) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Icon(Icons.location_on, color: primaryColor, size: 42),

          const SizedBox(height: 20),

          Text(
            city,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _footerItem(String title) {
    return Text(title, style: TextStyle(color: Colors.grey.shade400));
  }
}
