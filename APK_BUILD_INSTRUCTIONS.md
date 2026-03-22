# Android APK Build Instructions

## 🚀 Building APK for Testing

### Prerequisites
Before building the APK, ensure you have:
- ✅ Flutter SDK installed
- ✅ Android SDK installed
- ✅ Java Development Kit (JDK 11+)
- ✅ Android device or emulator configured

### Step 1: Install Flutter (If Not Already Installed)

```bash
# Download Flutter SDK from: https://flutter.dev/docs/get-started/install/windows
# Extract to a location like C:\flutter or C:\src\flutter
# Add to PATH: Control Panel → System → Environment Variables → Path → Add Flutter/bin path

# Verify installation
flutter doctor
```

### Step 2: Navigate to Project Directory

```bash
cd "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app"
```

### Step 3: Get Dependencies

```bash
flutter pub get
```

### Step 4: Build Debug APK (For Testing)

```bash
flutter build apk --debug
```

**Output Location:**
```
build/app/outputs/apk/debug/app-debug.apk
```

### Step 5: Build Release APK (For Production)

```bash
flutter build apk --release
```

**Output Location:**
```
build/app/outputs/apk/release/app-release.apk
```

---

## 📱 Installing APK on Device

### Using ADB (Android Debug Bridge)

```bash
# Connect Android device via USB (with USB debugging enabled)
# Or start Android emulator

# List connected devices
adb devices

# Install debug APK
adb install build/app/outputs/apk/debug/app-debug.apk

# Uninstall if needed
adb uninstall com.media_gallery.app
```

### Manual Installation

1. Transfer APK to Android device
2. Open Files app on device
3. Navigate to APK file
4. Tap to install
5. Follow on-screen prompts

---

## 🔧 Build Configuration

### Android Manifest Configuration
File: `android/app/src/main/AndroidManifest.xml`

Ensure these permissions are included:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Build Gradle Configuration
File: `android/app/build.gradle`

Key settings:
```gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "com.media_gallery.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
}
```

---

## 📦 APK Specifications

### Debug APK
- **Size**: ~50-70 MB (varies with dependencies)
- **Purpose**: Development and testing
- **Signature**: Debug key (auto-generated)
- **Performance**: Slightly slower, includes debug symbols
- **Installation**: Easier to install on development devices

### Release APK
- **Size**: ~35-50 MB (smaller than debug)
- **Purpose**: Production and distribution
- **Signature**: Release key (requires keystore)
- **Performance**: Optimized, minimal symbols
- **Installation**: Required for Play Store submission

---

## 🔐 Signing Release APK

To create a signed release APK for Play Store:

### Step 1: Create Keystore

```bash
keytool -genkey -v -keystore "C:\Users\karti\key.jks" `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias key
```

### Step 2: Configure gradle.properties

File: `android/key.properties`
```properties
storeFile=C:/Users/karti/key.jks
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=key
```

### Step 3: Configure build.gradle

File: `android/app/build.gradle`
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Step 4: Build Signed Release APK

```bash
flutter build apk --release
```

---

## ✅ Testing Checklist

### Pre-Build Verification
- [ ] `flutter doctor` shows no errors
- [ ] All dependencies in pubspec.yaml resolved
- [ ] Android SDK version 21+ available
- [ ] Build.gradle properly configured

### Post-Build Verification
- [ ] APK file created successfully
- [ ] APK size reasonable (35-70 MB)
- [ ] APK signature verified (if release build)
- [ ] APK installs on test device
- [ ] App launches without crashes
- [ ] All 3 screens accessible
- [ ] Google Sign-In works
- [ ] Photos load from Drive
- [ ] Refresh button functions

### Device Testing
- [ ] Test on actual Android device (minimum API 21)
- [ ] Test on emulator
- [ ] Test on different screen sizes
- [ ] Test offline behavior
- [ ] Test with no Google Drive access
- [ ] Test with slow internet
- [ ] Check battery usage
- [ ] Check data usage

---

## 🐛 Troubleshooting

### "flutter: command not found"
**Solution**: Add Flutter to PATH
```bash
# Find Flutter installation
Get-ChildItem -Path "C:\" -Filter flutter -Recurse -Directory

# Add to PATH in Environment Variables
# Path: {FlutterLocation}\bin
```

### "ANDROID_SDK_ROOT not found"
**Solution**: Set Android SDK location
```bash
$env:ANDROID_SDK_ROOT = "C:\Android\sdk"
flutter config --android-sdk "C:\Android\sdk"
```

### "Build failed: Unable to find bundletool"
**Solution**: Update Android SDK Build Tools
```bash
# In Android Studio: SDK Manager → Build Tools → Install latest
```

### "Gradle build failed"
**Solution**: Clean and rebuild
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### "APK too large"
**Solution**: Enable shrinking and obfuscation for release
```gradle
release {
    minifyEnabled true
    shrinkResources true
}
```

---

## 📊 Build Output Details

### Debug Build Output
```
✓ Built build\app\outputs\apk\debug\app-debug.apk (45.2 MB)
```

Location: `{ProjectRoot}/build/app/outputs/apk/debug/app-debug.apk`

### Release Build Output
```
✓ Built build\app\outputs\apk\release\app-release.apk (38.5 MB)
```

Location: `{ProjectRoot}/build/app/outputs/apk/release/app-release.apk`

---

## 🚀 Deployment Flow

```
1. Build APK
   ↓
2. Test on Device
   ↓
3. Fix Any Issues
   ↓
4. Build Release Version
   ↓
5. Sign APK
   ↓
6. Upload to Google Play Console
   ↓
7. Submit for Review
   ↓
8. Monitor Performance
```

---

## 📱 Google Play Store Submission

Once testing is complete:

1. **Prepare Store Listing**
   - App title, description
   - Screenshots (5-8 images)
   - Feature graphic
   - Icon (512x512 PNG)

2. **Upload APK**
   - Sign in to Google Play Console
   - Create new app
   - Upload signed release APK
   - Fill in store listing details

3. **Add Pricing**
   - Free or paid
   - Select countries
   - Add content rating questionnaire

4. **Submit for Review**
   - Review all content
   - Check compliance
   - Click "Submit"
   - Wait for review (usually 2-4 hours)

5. **Monitor**
   - Track installs
   - Monitor crash reports
   - Respond to user reviews

---

## 📞 Support

For more information:
- Flutter Build Documentation: https://flutter.dev/docs/deployment/android
- Android Development: https://developer.android.com/
- Google Play Console: https://play.google.com/console

---

**Status**: Ready to Build  
**Version**: 1.0  
**Last Updated**: 2026
