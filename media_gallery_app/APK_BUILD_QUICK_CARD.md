# ⚡ Quick APK Build Reference Card

## 🚀 Build Commands (Copy & Paste)

### Prerequisites Check
```powershell
flutter doctor
```

### Navigate to Project
```powershell
cd "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app"
```

### Get Dependencies
```powershell
flutter pub get
```

### Clean Build (If Issues)
```powershell
flutter clean
flutter pub get
```

---

## 📦 Build Commands

### DEBUG BUILD (For Testing)
```powershell
flutter build apk --debug
```
**Output**: `build/app/outputs/apk/debug/app-debug.apk` (~50 MB)  
**Speed**: Fast build (2-3 minutes)  
**Use**: Testing on devices  

### RELEASE BUILD (For Production)
```powershell
flutter build apk --release
```
**Output**: `build/app/outputs/apk/release/app-release.apk` (~35 MB)  
**Speed**: Slower build (5-8 minutes)  
**Use**: Google Play Store submission  

### SPLIT APK (Multiple Files for Different Devices)
```powershell
flutter build apk --release --split-per-abi
```
**Output**:
- `app-armeabi-v7a-release.apk` (~18 MB) - 32-bit
- `app-arm64-v8a-release.apk` (~22 MB) - 64-bit
- `app-x86_64-release.apk` (~22 MB) - Intel

**Use**: Smaller downloads, faster installation  

---

## 📱 Installation

### Using ADB
```powershell
# Install debug APK
adb install build/app/outputs/apk/debug/app-debug.apk

# Reinstall (force)
adb install -r build/app/outputs/apk/debug/app-debug.apk

# Uninstall
adb uninstall com.example.media_gallery_app
```

### Verify Installation
```powershell
adb shell pm list packages | findstr media
```

### View Logs
```powershell
adb logcat | findstr flutter
```

---

## ✅ Quick Testing Checklist

After building, test these:

- [ ] APK installs without errors
- [ ] App launches
- [ ] Home screen loads
- [ ] Photos display from Drive
- [ ] Can tap photos
- [ ] Refresh button works
- [ ] Videos screen works
- [ ] Info screen works
- [ ] No crashes in logs
- [ ] No permission errors

---

## 🎯 Step-by-Step Build Guide

### 1. Open Terminal (PowerShell)
```
Windows Key → Type "PowerShell" → Press Enter
```

### 2. Navigate to Project
```powershell
cd "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app"
```

### 3. Get Dependencies
```powershell
flutter pub get
```

### 4. Build APK
```powershell
flutter build apk --debug
```

### 5. Wait for Completion
```
✓ Built build\app\outputs\apk\debug\app-debug.apk
```

### 6. Find Your APK
```
📂 build/app/outputs/apk/debug/app-debug.apk
```

---

## 📊 Build Output Explained

### Successful Build
```
✓ Built build\app\outputs\apk\debug\app-debug.apk (48.2 MB).
```

### With Build Info
```
Running Gradle task 'assembleDebug'...
✓ Built build\app\outputs\apk\debug\app-debug.apk (48.2 MB).
Built in 2 minutes 34 seconds.
```

### What Each Part Means
- `✓` = Success
- `build\app\outputs\apk\` = Folder location
- `debug/` or `release/` = Build type
- `app-debug.apk` = File name
- `(48.2 MB)` = File size

---

## 🐛 If Build Fails

### Error: "flutter: command not found"
```powershell
# Add Flutter to PATH or use full path
C:\flutter\bin\flutter build apk --debug
```

### Error: "ANDROID_SDK_ROOT not set"
```powershell
$env:ANDROID_SDK_ROOT = "C:\Android\sdk"
flutter build apk --debug
```

### Error: "Gradle build failed"
```powershell
flutter clean
flutter pub get
flutter build apk --debug
```

### Error: "Build locked by another process"
```powershell
# Kill Gradle processes
taskkill /F /IM java.exe

# Retry build
flutter build apk --debug
```

---

## 📁 File Locations

### Find Your Built APK
```powershell
# Open File Explorer
explorer "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app\build\app\outputs\apk\debug\"

# Or copy APK to Desktop
Copy-Item -Path "build\app\outputs\apk\debug\app-debug.apk" -Destination "$env:USERPROFILE\Desktop\"
```

### View Build Details
```powershell
# List all built APKs
Get-ChildItem -Path "build\app\outputs\apk\" -Recurse -Filter "*.apk"
```

---

## 🚀 Testing on Device

### Connect Android Device
1. Connect via USB cable
2. Enable USB debugging on phone
3. Allow USB debugging permission
4. Verify in terminal: `adb devices`

### Install APK
```powershell
adb install build/app/outputs/apk/debug/app-debug.apk
```

### Launch App
```powershell
adb shell am start -n com.example.media_gallery_app/.MainActivity
```

### View Logs
```powershell
adb logcat | findstr flutter
```

---

## 📱 App Permissions

These are requested by the app:

```xml
android.permission.INTERNET
android.permission.ACCESS_NETWORK_STATE
android.permission.READ_EXTERNAL_STORAGE
android.permission.WRITE_EXTERNAL_STORAGE
android.permission.CAMERA
```

**Allow these when prompted during first launch.**

---

## ✨ Pro Tips

1. **Always test debug build first** before trying release
2. **Keep terminal open** to see real-time build progress
3. **Connect device early** so it's ready for testing
4. **Clear cache if issues** with `flutter clean`
5. **Check logs always** for hidden errors
6. **Build once, test thoroughly** before rebuilding
7. **Save APK files** before cleaning for backup

---

## 🎯 Build Decision Tree

```
Want to build?
├─ For testing on device?
│  └─ Use: flutter build apk --debug
│
├─ For Google Play Store?
│  └─ Use: flutter build apk --release
│
├─ For multiple devices (optimize size)?
│  └─ Use: flutter build apk --release --split-per-abi
│
└─ To optimize for specific device?
   └─ Use: flutter build apk --debug --target-platform android-arm64
```

---

## 📊 Build Times

| Type | Time | Notes |
|------|------|-------|
| Debug (first) | 3-5 min | Downloads gradle, dependencies |
| Debug (rebuild) | 1-2 min | Uses cache |
| Release (first) | 5-10 min | Includes optimization, signing |
| Release (rebuild) | 3-5 min | Faster with cache |

---

## 🎉 Success Indicators

✓ APK file created (size 35-50 MB)  
✓ No error messages in terminal  
✓ App installs without errors  
✓ App launches and shows home screen  
✓ Photos appear in gallery  
✓ No crashes on device  

---

**Last Updated**: March 22, 2026  
**Version**: 1.0  
**Ready**: For Immediate Use
