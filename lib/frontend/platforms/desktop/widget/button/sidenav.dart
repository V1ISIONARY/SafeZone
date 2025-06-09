import 'package:flutter/material.dart';
import 'package:safezone/backend/properties/properties.dart';
import '../../../../../backend/properties/import.dart';

class Sidenav extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool? withDrop;
  final VoidCallback? onTap;
  final List<Widget>? hoverTrailing;
  final List<DropdownItem>? dropdownItems;

  static final ValueNotifier<String?> selectedLabel = ValueNotifier("Zones");

  const Sidenav({
    Key? key,
    required this.icon,
    required this.label,
    this.hoverTrailing,
    this.withDrop,
    this.onTap,
    this.dropdownItems,
  }) : super(key: key);

  @override
  State<Sidenav> createState() => _SidenavState();
}

class DropdownItem {
  final String label;
  final String? icon;
  final VoidCallback onTap;

  DropdownItem({
    required this.label,
    required this.onTap,
    this.icon,
  });
}

final sharedController = SharedProperties();

class _SidenavState extends State<Sidenav> {
  bool _hovering = false;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    Sidenav.selectedLabel.addListener(_onSelectedLabelChanged);
  }

  @override
  void dispose() {
    Sidenav.selectedLabel.removeListener(_onSelectedLabelChanged);
    super.dispose();
  }

  void _onSelectedLabelChanged() {
    setState(() {});
  }

  void _handleTap() {
    if (widget.withDrop == true) {
      if (!sharedController.isSidebarCollapsed) {
        setState(() {
          _showDropdown = !_showDropdown;
        });
      }
    } else {
      Sidenav.selectedLabel.value = widget.label;
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = Sidenav.selectedLabel.value == widget.label;
    final bool isDropdown = widget.withDrop == true;

    final Color backgroundColor = isDropdown
        ? Colors.transparent
        : (isSelected
            ? Colors.grey.shade300
            : (_hovering ? Colors.grey.shade50 : Colors.transparent));

    final Color iconColor = Colors.black54;
    final Color textColor = Colors.black54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
            child: sharedController.isSidebarCollapsed
                ? ShiftedTooltip(
                    message: widget.label,
                    horizontalOffset: 20,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: _handleTap,
                      onHover: (hovering) {
                        setState(() {
                          _hovering = hovering;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: Icon(widget.icon, color: iconColor, size: 15),
                      ),
                    ),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: _handleTap,
                    onHover: (hovering) {
                      setState(() {
                        _hovering = hovering;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(widget.icon, color: iconColor, size: 15),
                          const SizedBox(width: 5),
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          if (_hovering && widget.hoverTrailing != null)
                            Row(
                              children: widget.hoverTrailing!.map((child) {
                                if (child is Text) {
                                  return Text(
                                    child.data ?? '',
                                    style: child.style?.copyWith(
                                          color: Colors.black38,
                                        ) ??
                                        const TextStyle(
                                            color: Colors.black38, fontSize: 10),
                                  );
                                } else if (child is Icon) {
                                  return Icon(
                                    child.icon,
                                    color: Colors.black38,
                                    size: child.size,
                                  );
                                } else {
                                  return child;
                                }
                              }).toList(),
                            ),
                          if (isDropdown)
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                _showDropdown
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 12,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        if (_showDropdown && widget.dropdownItems != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.dropdownItems!
                .map((item) => _buildDropdownButton(context, item))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildDropdownButton(
    BuildContext context,
    DropdownItem item,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 5),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShiftedTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final double horizontalOffset;
  final Decoration? decoration;
  final TextStyle? textStyle;

  const ShiftedTooltip({
    Key? key,
    required this.child,
    required this.message,
    this.horizontalOffset = 20,
    this.decoration,
    this.textStyle,
  }) : super(key: key);

  @override
  State<ShiftedTooltip> createState() => _ShiftedTooltipState();
}

class _ShiftedTooltipState extends State<ShiftedTooltip> {
  OverlayEntry? _overlayEntry;

  void _showTooltip() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + 5,
        left: offset.dx + 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: widget.decoration ??
              BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
            child: Text(
              widget.message,
              style: widget.textStyle ??
                const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _hideTooltip();
        },
        child: widget.child,
      ),
    );
  }
}
