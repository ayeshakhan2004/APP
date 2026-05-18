<<<<<<< HEAD
import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  DESIGN TOKENS  —  Single unified green gradient theme
// ─────────────────────────────────────────────────────────────
class _C {
  // Brand gradient
  static const g1 = Color(0xFF00E87A); // neon mint-green
  static const g2 = Color(0xFF00C6FF); // cyan-blue

  // Background
  static const bg = Color(0xFF030C0F);

  // Semantic (kept for alert readability only)
  static const danger  = Color(0xFFFF4D6D);
  static const warning = Color(0xFFFFB347);
  static const safe    = Color(0xFF00E87A);

  // Text
  static const textPrimary   = Colors.white;
  static const textSecondary = Color(0xFF9EB3B8);
  static const textMuted     = Color(0xFF3D5A60);

  static List<Color> get brand => [g1, g2];
  static Color glW(double o)   => Colors.white.withOpacity(o);
}

// ─────────────────────────────────────────────────────────────
//  BRAND GRADIENT TEXT
// ─────────────────────────────────────────────────────────────
class _BrandText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const _BrandText(this.text, {required this.style});

  @override
  Widget build(BuildContext context) => ShaderMask(
        shaderCallback: (r) =>
            const LinearGradient(colors: [_C.g1, _C.g2]).createShader(r),
        child: Text(text, style: style.copyWith(color: Colors.white)),
      );
}

// ─────────────────────────────────────────────────────────────
//  HOVER GLASS CARD
// ─────────────────────────────────────────────────────────────
class _HoverCard extends StatefulWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  const _HoverCard({
    required this.child,
    this.radius = 24,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
  late final Animation<double> _t =
      CurvedAnimation(parent: _ac, curve: Curves.easeOut);

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ac.forward(),
      onExit:  (_) => _ac.reverse(),
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final v = _t.value;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 28, offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: _C.g1.withOpacity(0.18 * v),
                  blurRadius: 55, spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    color: Colors.white.withOpacity(0.04 + 0.04 * v),
                    border: Border.all(
                      color: _C.g1.withOpacity(0.08 + 0.18 * v),
                      width: 1.0,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STAT CARD
// ─────────────────────────────────────────────────────────────
class _StatCard extends StatefulWidget {
  final String title, value;
  final IconData icon;
  const _StatCard({required this.title, required this.value, required this.icon});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
  late final Animation<double> _t =
      CurvedAnimation(parent: _ac, curve: Curves.easeOutBack);

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ac.forward(),
      onExit:  (_) => _ac.reverse(),
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final v = _t.value;
          return Transform.scale(
            scale: 1.0 + 0.028 * v,
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 28, offset: const Offset(0, 14),
                  ),
                  BoxShadow(
                    color: _C.g1.withOpacity(0.28 * v),
                    blurRadius: 60, spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: _C.g2.withOpacity(0.15 * v),
                    blurRadius: 90, spreadRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _C.g1.withOpacity(0.10 + 0.15 * v),
                          _C.g2.withOpacity(0.05 + 0.08 * v),
                          Colors.white.withOpacity(0.01),
                        ],
                      ),
                      border: Border.all(
                        color: _C.g1.withOpacity(0.12 + 0.35 * v),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _C.brand,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _C.g1.withOpacity(0.45 + 0.35 * v),
                                blurRadius: 18 + 16 * v, spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(widget.icon, color: Colors.white, size: 22),
                        ),
                        const Spacer(),
                        _BrandText(
                          widget.value,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.title,
                          style: const TextStyle(
                            color: _C.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ALERT TILE  —  ⚠️ NO child= param in AnimatedBuilder
//  (Flutter Web: BackdropFilter clips child when child= is used)
// ─────────────────────────────────────────────────────────────
class _AlertTile extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final Color color;

  const _AlertTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  State<_AlertTile> createState() => _AlertTileState();
}

class _AlertTileState extends State<_AlertTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final Animation<double> _t =
      CurvedAnimation(parent: _ac, curve: Curves.easeOut);

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ac.forward(),
      onExit:  (_) => _ac.reverse(),
      child: AnimatedBuilder(
        animation: _t,
        builder: (ctx, _) {          // ← no child= intentional
          final v = _t.value;
          return Transform.translate(
            offset: Offset(5 * v, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 22, offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: widget.color.withOpacity(0.22 * v),
                    blurRadius: 44, spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white.withOpacity(0.04 + 0.04 * v),
                      border: Border(
                        left:   BorderSide(color: widget.color.withOpacity(0.35 + 0.50 * v), width: 2.5),
                        top:    BorderSide(color: _C.glW(0.05 + 0.06 * v)),
                        right:  BorderSide(color: _C.glW(0.04 + 0.04 * v)),
                        bottom: BorderSide(color: _C.glW(0.04 + 0.04 * v)),
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color.withOpacity(0.12),
                          border: Border.all(
                            color: widget.color.withOpacity(0.20 + 0.30 * v),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.22 * v),
                              blurRadius: 18, spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: widget.color, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title,
                              style: const TextStyle(
                                color: _C.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              )),
                            const SizedBox(height: 4),
                            Text(widget.subtitle,
                              style: const TextStyle(
                                color: _C.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withOpacity(0.22 + 0.45 * v),
                        size: 14,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ACTIVITY ROW  —  same fix
// ─────────────────────────────────────────────────────────────
class _ActivityRow extends StatefulWidget {
  final IconData icon;
  final String title, time;
  const _ActivityRow({required this.icon, required this.title, required this.time});

  @override
  State<_ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<_ActivityRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  late final Animation<double> _t =
      CurvedAnimation(parent: _ac, curve: Curves.easeOut);

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ac.forward(),
      onExit:  (_) => _ac.reverse(),
      child: AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final v = _t.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withOpacity(0.04 * v),
            ),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    _C.g1.withOpacity(0.15 + 0.15 * v),
                    _C.g2.withOpacity(0.10 + 0.10 * v),
                  ]),
                  boxShadow: [
                    BoxShadow(
                      color: _C.g1.withOpacity(0.25 * v),
                      blurRadius: 14, spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(widget.icon,
                    color: Color.lerp(_C.textSecondary, _C.g1, v), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(widget.title,
                  style: const TextStyle(
                    color: _C.textPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  )),
              ),
              Text(widget.time,
                style: const TextStyle(color: _C.textMuted, fontSize: 12)),
            ]),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ANIMATED ORB
// ─────────────────────────────────────────────────────────────
class _Orb extends StatefulWidget {
  final double size, top, left, opacity;
  final Duration duration;
  final Color color;
  const _Orb({
    required this.size, required this.top, required this.left,
    required this.duration, required this.color, this.opacity = 0.16,
  });

  @override
  State<_Orb> createState() => _OrbState();
}

class _OrbState extends State<_Orb> with SingleTickerProviderStateMixin {
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: widget.duration)
        ..repeat(reverse: true);
  late final Animation<double> _s =
      Tween<double>(begin: 0.85, end: 1.15)
          .animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));
  late final Animation<double> _o =
      Tween<double>(begin: widget.opacity * 0.55, end: widget.opacity)
          .animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Positioned(
    top: widget.top, left: widget.left,
    child: AnimatedBuilder(
      animation: _ac,
      builder: (_, __) => Transform.scale(
        scale: _s.value,
        child: Container(
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              widget.color.withOpacity(_o.value),
              widget.color.withOpacity(0),
            ]),
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────────────────────────
class _Section extends StatelessWidget {
  final String label;
  const _Section(this.label);

  @override
  Widget build(BuildContext context) => Row(children: [
    _BrandText(label, style: const TextStyle(
      fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
    const SizedBox(width: 14),
    Expanded(
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            _C.g1.withOpacity(0.25),
            _C.g2.withOpacity(0.10),
            Colors.transparent,
          ]),
        ),
      ),
    ),
  ]);
}

// ─────────────────────────────────────────────────────────────
//  GRID PAINTER
// ─────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _C.g1.withOpacity(0.018)
      ..strokeWidth = 0.5;
    const s = 60.0;
    for (double x = 0; x < size.width; x += s) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += s) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────
//  DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  Offset _mouse = const Offset(300, 300);

  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _ac, curve: Curves.easeIn);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.06), end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutExpo));

  @override
  void initState() { super.initState(); _ac.forward(); }

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  static const _stats = [
    (title: 'Active Crises',  value: '12',  icon: Icons.warning_amber_rounded),
    (title: 'Resources',      value: '48',  icon: Icons.inventory_2_outlined),
    (title: 'Alerts Sent',    value: '126', icon: Icons.notifications_active_outlined),
    (title: 'Safe Zones',     value: '16',  icon: Icons.shield_outlined),
  ];

  Widget _statsGrid(BuildContext context, BoxConstraints c) {
    if (c.maxWidth > 700) {
      return Column(children: [
        Row(children: [
          Expanded(child: _StatCard(title: _stats[0].title, value: _stats[0].value, icon: _stats[0].icon)),
          const SizedBox(width: 14),
          Expanded(child: _StatCard(title: _stats[1].title, value: _stats[1].value, icon: _stats[1].icon)),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _StatCard(title: _stats[2].title, value: _stats[2].value, icon: _stats[2].icon)),
          const SizedBox(width: 14),
          Expanded(child: _StatCard(title: _stats[3].title, value: _stats[3].value, icon: _stats[3].icon)),
        ]),
      ]);
    }
    return Column(children: [
      for (final s in _stats) ...[
        _StatCard(title: s.title, value: s.value, icon: s.icon),
        const SizedBox(height: 14),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => setState(() => _mouse = e.localPosition),
      child: Scaffold(
        backgroundColor: _C.bg,
        body: Stack(children: [

          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // Green orbs
          _Orb(color: _C.g1, size: 500, top: -180, left: -120,
              duration: const Duration(seconds: 8), opacity: 0.12),
          _Orb(color: _C.g2, size: 380, top: 180, left: -60,
              duration: const Duration(seconds: 10), opacity: 0.09),
          _Orb(color: _C.g1, size: 260, top: 480, left: 400,
              duration: const Duration(seconds: 7), opacity: 0.07),
          _Orb(color: _C.g2, size: 300, top: 80, left: 480,
              duration: const Duration(seconds: 12), opacity: 0.06),

          // Mouse glow
          Positioned(
            left: _mouse.dx - 220,
            top:  _mouse.dy - 220,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                width: 440, height: 440,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    _C.g1.withOpacity(0.13),
                    _C.g2.withOpacity(0.06),
                    Colors.transparent,
                  ], stops: const [0.0, 0.4, 1.0]),
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Top bar
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 14, spacing: 14,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              _BrandText('CIRO', style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w900,
                                letterSpacing: 2.0)),
                              const SizedBox(width: 10),
                              const Text('Dashboard', style: TextStyle(
                                color: _C.textSecondary, fontSize: 20,
                                fontWeight: FontWeight.w400)),
                            ],
                          ),
                          _HoverCard(
                            radius: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_rounded, color: _C.textSecondary, size: 18),
                                const SizedBox(width: 10),
                                const Text('Search...', style: TextStyle(
                                    color: _C.textMuted, fontSize: 14)),
                                const SizedBox(width: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: _C.g1.withOpacity(0.08),
                                    border: Border.all(color: _C.g1.withOpacity(0.18)),
                                  ),
                                  child: const Text('⌘ K', style: TextStyle(
                                      color: _C.textMuted, fontSize: 11, letterSpacing: 0.5)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 36),

                      // Hero header
                      Row(children: [
                        Container(
                          width: 5, height: 46,
                          margin: const EdgeInsets.only(right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [_C.g1, _C.g2],
                            ),
                            boxShadow: [BoxShadow(
                              color: _C.g1.withOpacity(0.6),
                              blurRadius: 14, spreadRadius: 1,
                            )],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Emergency Overview',
                              style: TextStyle(
                                color: _C.textPrimary,
                                fontSize: 34, fontWeight: FontWeight.w800,
                                letterSpacing: -0.8, height: 1.1,
                              )),
                            SizedBox(height: 6),
                            Text('Monitor crises and emergency response in real time.',
                              style: TextStyle(color: _C.textSecondary, fontSize: 14.5)),
                          ],
                        ),
                      ]),

                      const SizedBox(height: 30),

                      LayoutBuilder(builder: _statsGrid),

                      const SizedBox(height: 36),

                      const _Section('Live Alerts'),
                      const SizedBox(height: 16),

                      const _AlertTile(
                        icon: Icons.flood,
                        title: 'Flood Warning',
                        subtitle: 'High water levels detected in Sector 12',
                        color: _C.danger,
                      ),
                      const SizedBox(height: 12),
                      const _AlertTile(
                        icon: Icons.medical_services_outlined,
                        title: 'Medical Emergency',
                        subtitle: 'Ambulance dispatched near Downtown',
                        color: _C.warning,
                      ),
                      const SizedBox(height: 12),
                      const _AlertTile(
                        icon: Icons.home_work_outlined,
                        title: 'Shelter Activated',
                        subtitle: 'Emergency shelter opened in City Hall',
                        color: _C.safe,
                      ),

                      const SizedBox(height: 36),

                      const _Section('Recent Activity'),
                      const SizedBox(height: 16),

                      _HoverCard(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        radius: 24,
                        child: const Column(children: [
                          _ActivityRow(
                            icon: Icons.location_on_outlined,
                            title: 'Rescue team deployed',
                            time: '2 min ago',
                          ),
                          Divider(color: Color(0x0FFFFFFF), height: 1),
                          _ActivityRow(
                            icon: Icons.wifi_tethering,
                            title: 'Emergency signal received',
                            time: '5 min ago',
                          ),
                          Divider(color: Color(0x0FFFFFFF), height: 1),
                          _ActivityRow(
                            icon: Icons.check_circle_outline,
                            title: 'Area marked safe',
                            time: '10 min ago',
                          ),
                        ]),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
=======
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CIRO Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard('Active Crises', '2', Colors.red),
            const SizedBox(height: 16),
            _buildStatCard('Resources Deployed', '8', Colors.blue),
            const SizedBox(height: 16),
            _buildStatCard('Alerts Sent', '14', Colors.orange),
            const SizedBox(height: 24),
            const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Expanded(
              child: Center(child: Text('Simulated signals flowing...')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16)),
          Text(value, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
>>>>>>> origin/main
      ),
    );
  }
}
