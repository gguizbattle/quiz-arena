# Quiz Arena Mobile — Claude Instructions

## Language Requirement (MANDATORY)

Every UI string added to this project MUST support all 4 languages:
- **az** — Azerbaijani (primary/default)
- **en** — English
- **ru** — Russian
- **tr** — Turkish

### How to add new strings

1. Add the key to **all 4 ARB files** in `lib/l10n/`:
   - `app_az.arb` — Azerbaijani (template file, also has `@key` metadata)
   - `app_en.arb` — English
   - `app_ru.arb` — Russian
   - `app_tr.arb` — Turkish

2. For parametrized strings, add placeholder metadata in `app_az.arb`:
   ```json
   "myKey": "Salam {name}!",
   "@myKey": {
     "placeholders": {
       "name": { "type": "String" }
     }
   }
   ```

3. Run code generation after editing ARB files:
   ```
   flutter gen-l10n
   ```

4. Use in code:
   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.myKey)
   ```

### Import path
```dart
import 'package:gguiz_battle/app_localizations.dart';
```

### Language selector widget
Use the shared widgets — do NOT duplicate language-switching logic:
```dart
import '../../../../core/widgets/language_selector.dart';

// Full bottom sheet:
showLanguageSelector(context, ref);

// Compact button (for screen headers):
const LanguageButton()
```

### Never use hardcoded strings
Never write hardcoded UI text directly in widget code. Always use `l10n.keyName`.

## Architecture Notes
- Locale state: `localeProvider` (Riverpod `StateNotifierProvider<LocaleNotifier, Locale>`)
- Persisted via `SharedPreferences` — survives app restarts
- Default locale: `Locale('az')` (Azerbaijani)
- Supported locales defined in `lib/core/providers/locale_provider.dart`
