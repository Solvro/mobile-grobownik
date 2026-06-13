import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class BodyTextStyle extends TextStyle {
  BodyTextStyle({super.fontSize = 16.0, super.fontWeight = FontWeight.normal, super.color, super.letterSpacing})
    : super(fontFamily: GoogleFonts.roboto().fontFamily);
}

class HeadlineTextStyle extends TextStyle {
  HeadlineTextStyle({super.fontSize, super.fontWeight = FontWeight.bold, super.color, super.letterSpacing})
    : super(fontFamily: GoogleFonts.robotoSlab().fontFamily);
}

class BodyMediumTextStyle extends BodyTextStyle {
  BodyMediumTextStyle({super.color}) : super(fontSize: 16);
}

class BodyLargeTextStyle extends BodyTextStyle {
  BodyLargeTextStyle({super.color}) : super(fontSize: 20);
}

class HeadlineSmallTextStyle extends HeadlineTextStyle {
  HeadlineSmallTextStyle({super.color}) : super(fontSize: 18);
}

class HeadlineMediumTextStyle extends HeadlineTextStyle {
  HeadlineMediumTextStyle({super.color}) : super(fontSize: 24, letterSpacing: 0.15);
}
