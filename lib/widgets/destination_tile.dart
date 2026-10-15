import 'package:flutter/material.dart';

/// Кнопка перехода на раздел: одна интерактивная поверхность, без «карточной сетки».
class DestinationTile extends StatefulWidget {
  const DestinationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.emphasized = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool emphasized;

  @override
  State<DestinationTile> createState() => _DestinationTileState();
}

class _DestinationTileState extends State<DestinationTile> {
  var _hovered = false;
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = _pressed ? 0.985 : (_hovered ? 1.015 : 1.0);
    final bg = widget.emphasized
        ? scheme.primary
        : (isDark ? const Color(0xFF142826) : Colors.white);
    final fg = widget.emphasized ? scheme.onPrimary : scheme.onSurface;
    final muted = widget.emphasized
        ? scheme.onPrimary.withValues(alpha: 0.82)
        : scheme.onSurfaceVariant;
    final border = widget.emphasized
        ? Colors.transparent
        : scheme.outline.withValues(alpha: 0.9);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
              boxShadow: _hovered && !widget.emphasized
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: widget.emphasized
                        ? Colors.white.withValues(alpha: 0.16)
                        : scheme.primary.withValues(
                            alpha: isDark ? 0.18 : 0.10,
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.emphasized ? fg : scheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: fg, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: muted),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded, color: muted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
