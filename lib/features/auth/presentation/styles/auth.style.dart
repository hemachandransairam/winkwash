import "package:flutter/material.dart";
import "package:mix/mix.dart";

class AuthStyle {
  static final container = Style(
    $box.color(Colors.white),
    $box.padding.horizontal(24),
  );

  static final title = Style(
    $text.style.fontSize(28),
    $text.style.fontWeight(FontWeight.bold),
    $text.style.color(const Color(0xFF1A1A1A)),
  );

  static final subtitle = Style(
    $text.style.fontSize(14),
    $text.style.color(Colors.grey),
    $text.textAlign.center(),
  );

  static final inputLabel = Style(
    $text.style.fontSize(15),
    $text.style.fontWeight(FontWeight.bold),
  );

  static final textField = Style(
    $box.color(const Color(0xFFFAFAFA)),
    $box.borderRadius.all(12),
    $box.padding.horizontal(16),
    $box.padding.vertical(14),
    $box.border.all(color: Colors.grey.shade100, width: 1),
  );

  static final textFieldFocused = Style(
    $box.border.all(color: const Color(0xFF000814), width: 1),
  );

  static final primaryButton = Style(
    $box.color(const Color(0xFF000B1E)),
    $box.borderRadius.all(30),
    $box.width(double.infinity),
    $box.height(52),
    $box.alignment.center(),
    $text.style.color(Colors.white),
    $text.style.fontSize(16),
    $text.style.fontWeight(FontWeight.bold),
  );

  static final primaryButtonDisabled = Style(
    $box.color(Colors.grey.shade300),
    $text.style.color(Colors.grey.shade600),
  );

  static final socialButton = Style(
    $box.width(50),
    $box.height(50),
    $box.padding.all(12),
    $box.shape.circle(),
    $box.border.all(color: Colors.grey.shade200, width: 1),
  );
}
