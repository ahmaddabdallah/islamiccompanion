# 🛠 Bug Fix & Improvement Plan – Islamic App

This plan outlines the current bugs in the app and steps to fix them.

---

## 1. 🌍 Language Tab (Not Working)
### Problem:
- Language switching tab is not functioning.
- Currently stuck in Arabic or English without toggle.

### Possible Causes:
- Missing i18n (internationalization) configuration.
- State management not updating on language change.
- UI components not rerendering after language update.

### Fix Plan:
1. Integrate `i18next` or `react-native-localize`.
2. Store selected language in `AsyncStorage`.
3. Ensure UI re-renders when language state changes.
4. Test switching between Arabic ↔ English.

---

## 2. 🌙 Dark/Light Mode (Not Working)
### Problem:
- Dark mode toggle doesn’t apply across all screens.

### Possible Causes:
- Theme context not applied globally.
- Some components hardcoded with light styles.

### Fix Plan:
1. Implement `ThemeContext` or use React Native `Appearance API`.
2. Apply global styles via `ThemeProvider`.
3. Fix hardcoded colors → replace with theme variables.
4. Test switching system theme & manual toggle.

---

## 3. 📍 Location Access (Not Working)
### Problem:
- Prayer times not accurate because location is not fetched.
- Location permission not working.

### Possible Causes:
- Missing permission in `AndroidManifest.xml` / `Info.plist`.
- Location API not implemented or broken.

### Fix Plan:
1. Add permissions:
   - Android: `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`.
   - iOS: Add location usage description.
2. Use `react-native-geolocation-service` or Expo Location.
3. Fallback: Default to **Cairo, Egypt** if GPS fails.
4. Recalculate prayer times using location coordinates.

---

## 4. 🕋 Qibla Direction (Not Working or Wrong)
### Problem:
- Qibla compass not showing or showing wrong direction.

### Possible Causes:
- Compass sensor not initialized.
- Wrong formula for Qibla bearing.
- Location not fetched → calculation fails.

### Fix Plan:
1. Get user coordinates via GPS.
2. Calculate Qibla using formula:
3. Use the Best Way to solve this bug
4. Test orientation on multiple devices.

---

## 5. 📖 Quran Tab (Error/Bug)
### Problem:
- Quran tab not loading, app crashes or shows blank screen.

### Possible Causes:
- API integration broken (Quran API not responding).
- Parsing error in JSON response.
- Incorrect routing/navigation.

### Fix Plan:
1. Use trusted Quran API (e.g., Quran.com API).
2. Implement error handling if API fails.
3. Lazy load surahs/ayahs for better performance.
4. Test search, audio recitation, and bookmark features.

---

# ✅ Testing Plan
1. Test each fix on Android & iOS.
2. Simulate offline mode to ensure app doesn’t crash.
3. Unit test key components (Prayer API, Quran API, Tasbeeh).
4. Collect beta tester feedback.

---

# 🚀 Future Improvements
- Add **offline Quran** option.
- Add **auto-adjust prayer times**.
- Improve **Dhikr counter stats dashboard**.
- Multi-reciter Quran audio support.
