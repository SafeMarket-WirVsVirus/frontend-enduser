# Creating Localizations

1. Add your new strings to `safe_market_strings.dart`
1. Run `./scripts/create_translations.sh` to extract the added strings from the dart file to `l10n/intl_messages.arb`
1. Translate the new strings in the `intl_messages_*.arb` files
1. Run `./scripts/integrate_translations.sh` to generate the `messages_*.dart` files which are used by the app.
