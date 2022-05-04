import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sunny_essentials/sunny_essentials.dart';

class ChipButton extends StatefulWidget {
  final String label;
  final AsyncCallback? onPressed;
  final bool dense;

  const ChipButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.dense = false,
  }) : super(key: key);

  @override
  _ChipButtonState createState() => _ChipButtonState();
}

class _ChipButtonState extends State<ChipButton> {
  bool _processing = false;
  EdgeInsets? _padding;

  void _doTap() {
    if (widget.onPressed == null) return;

    setState(() {
      _processing = true;
    });

    widget.onPressed!().whenComplete(() {
      if (mounted) {
        setState(() {
          _processing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _padding ??= widget.dense
        ? EdgeInsets.symmetric(vertical: 4.5.px, horizontal: 12.px)
        : EdgeInsets.symmetric(vertical: 6.px, horizontal: 14.px);
    return InputChip(
      label: widget.dense == true
          ? Body2Text.medium(widget.label)
          : Body1Text.medium(widget.label),
      visualDensity:
          widget.dense == true ? VisualDensity.compact : VisualDensity.standard,
      labelPadding: _padding,
//      padding: EdgeInsets.zero,
      backgroundColor: sunnyColors.g100,
      isEnabled: _processing != true,
      onPressed: () => _doTap(),
    );
  }
}
