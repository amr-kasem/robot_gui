import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/services.dart';

class WayPointWidget extends StatefulWidget {
  const WayPointWidget({
    Key? key,
    this.editable = false,
    required this.onDelete,
    required this.id,
    required this.lat,
    required this.lng,
  }) : super(key: key);
  final int id;
  final bool editable;
  final VoidCallback onDelete;
  final double lat, lng;

  @override
  State<WayPointWidget> createState() => _WayPointWidgetState();
}

class HideMenuIntent extends Intent {
  const HideMenuIntent();
}

class _WayPointWidgetState extends State<WayPointWidget> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    var _marker = AnimatedScale(
      duration: const Duration(milliseconds: 150),
      scale: hover ? 1.1 : 1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Tooltip(
            richMessage: WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text('خط طول :'),
                        ),
                        Text(widget.lng.toStringAsFixed(7)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text('دائرة عرض :'),
                        ),
                        Text(widget.lat.toStringAsFixed(7)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            child: Icon(
              material.Icons.location_on,
              color: Colors.blue.normal,
              size: 40,
            ),
          ),
          if (widget.editable)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    FluentIcons.remove,
                    size: 10,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.onDelete();
                  },
                ),
              ),
            ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.id.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
      cursor: SystemMouseCursors.basic,
      child: widget.editable
          ? ContextMenuArea(
              width: 180,
              verticalPadding: 20,
              builder: (BuildContext context) => [
                Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.escape):
                        const HideMenuIntent(),
                  },
                  child: Actions(
                    actions: {
                      HideMenuIntent: CallbackAction<HideMenuIntent>(
                        onInvoke: (HideMenuIntent intent) =>
                            Navigator.of(context).pop(),
                      ),
                    },
                    child: Focus(
                      autofocus: true,
                      child: Column(
                        children: [
                          TappableListTile(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            leading: const Icon(FluentIcons.move),
                            title: const Text('Modify'),
                          ),
                          TappableListTile(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            leading:
                                const Icon(material.Icons.move_down_rounded),
                            title: const Text('Change index'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              child: _marker,
            )
          : _marker,
    );
  }
}
