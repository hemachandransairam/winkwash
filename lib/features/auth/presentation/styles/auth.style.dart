import "package:flutter/material.dart";
import "package:mix/mix.dart";

class AuthStyle {
  static final container = Style(
    $box.padding.all(24),
    $box.color(Colors.white),
  );

  static final title = Style(
    $text.style.fontSize(32),
    $text.style.fontWeight(FontWeight.bold),
    $text.style.color(Colors.black),
  );

  static final inputField = Style(
    $box.padding.horizontal(16),
    $box.padding.vertical(8),
    $box.borderRadius.all(8),
    $box.border.all(color: Colors.grey, width: 1),
  );
}
