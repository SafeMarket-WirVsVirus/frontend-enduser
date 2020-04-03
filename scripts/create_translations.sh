#!/bin/bash

# Run this script to create the files in lib/localization/l10n/* which you can then translate.
flutter pub run intl_translation:extract_to_arb --suppress-meta-data --suppress-last-modified --output-dir=lib/localization/l10n lib/localization/safe_market_strings.dart