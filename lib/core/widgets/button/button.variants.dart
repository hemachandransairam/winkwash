import "package:flutter/material.dart";
import "package:mix/mix.dart";

final secondaryButtonVariant = Variant("secondary");

final secondaryButtonVariantStyle = Style(
  secondaryButtonVariant(
    $box.color(Colors.grey),
    $text.style.color(Colors.black),
  ),
);
