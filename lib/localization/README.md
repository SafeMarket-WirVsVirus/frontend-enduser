# Creating Localizations

1. Add your new strings to `safe_market_strings.dart`
2. Run `./scripts/create_translations.sh` to extract the added strings from the dart file to `l10n/intl_messages.arb`
3. Copy the generated lines from `l10n/intl_messages.arb` do the respective language specific .arb file (`intl_messages_*.arb`)
4. Translate the new strings in the `intl_messages_*.arb` files
5. Run `./scripts/integrate_translations.sh` to generate the `messages_*.dart` files which are used by the app.
