#!/bin/bash

# Run this script to integrate the translated strings in the app
flutter pub run intl_translation:generate_from_arb --suppress-warnings --output-dir=lib/localization/gen --no-use-deferred-loading lib/localization/safe_market_strings.dart lib/localization/l10n/intl_*.arb
