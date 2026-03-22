# 🚀 Flutter SDK Installation Guide - Windows

## Problem
```
flutter : The term 'flutter' is not recognized...
```

**Solution**: Install Flutter SDK

---

## ✅ Option 1: Fastest Installation (Recommended)

### Step 1: Download Flutter SDK
1. Go to: https://flutter.dev/docs/get-started/install/windows
2. Click **"Download Flutter SDK"** button
3. Choose version for Windows
4. Save to: `C:\flutter` (or `C:\src\flutter`)

### Step 2: Extract Flutter
1. Extract downloaded ZIP file to `C:\flutter`
2. You should see folders: `bin`, `packages`, `examples`, etc.

### Step 3: Add to System PATH
```powershell
# Right-click "This PC" or "My Computer"
# Click "Properties"
# Click "Advanced system settings"
# Click "Environment Variables" button
# Under "System variables", click "New..."
# Variable name: Path
# Variable value: C:\flutter\bin
# Click "OK" on all dialogs
```

### Step 4: Verify Installation
```powershell
# Close PowerShell completely
# Open new PowerShell window
# Run:
flutter doctor
```

**Expected output:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Windows 11.x.x)
[✓] Windows Version (Windows 11.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android SDK
...
```

---

## ✅ Option 2: Using Chocolatey (Easiest on Windows)

### Step 1: Install Chocolatey (if not already installed)
```powershell
# Open PowerShell as Administrator
# Run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://community.chocolatey.org/install.ps1 | iex
```

### Step 2: Install Flutter
```powershell
# Run:
choco install flutter -y
```

### Step 3: Verify
```powershell
flutter doctor
```

---

## ✅ Option 3: Using Windows Package Manager (if available)

```powershell
winget install Google.Flutter
```

---

## 🔍 Troubleshooting

### "Flutter still not recognized"
```powershell
# Restart computer completely

# Or add Flutter path manually:
$env:Path += ";C:\flutter\bin"

# Verify:
flutter --version
```

### "flutter doctor shows errors"
```powershell
# Fix issues:
flutter doctor --android-licenses
# Accept all licenses by typing 'y'

# Check again:
flutter doctor
```

### "Android SDK not found"
```powershell
# Install through Android Studio:
# 1. Download Android Studio: https://developer.android.com/studio
# 2. Install it
# 3. Open Android Studio
# 4. Tools → SDK Manager
# 5. Install SDK Platform (API 21+)
# 6. Install Build Tools

# Or set manually:
flutter config --android-sdk "C:\Android\sdk"
```

---

## ✅ Minimal Requirements Check

```powershell
# These should all pass:

# 1. Flutter installed
flutter --version

# 2. Java installed
java -version

# 3. Git installed
git --version

# 4. Android SDK
flutter doctor
```

---

## 🚀 After Installation - Build APK

Once Flutter is installed and `flutter doctor` shows all ✓:

```powershell
cd "C:\Users\karti\OneDrive\Desktop\App\media_gallery_app"
flutter pub get
flutter build apk --debug
```

**Wait 2-5 minutes for build to complete...**

```
✓ Built build\app\outputs\apk\debug\app-debug.apk (48 MB)
```

---

## 📋 Installation Checklist

- [ ] Downloaded Flutter SDK
- [ ] Extracted to C:\flutter
- [ ] Added C:\flutter\bin to PATH
- [ ] Restarted PowerShell
- [ ] Ran `flutter doctor`
- [ ] No ✗ errors in output
- [ ] Android SDK installed (shown in flutter doctor)
- [ ] Java installed (shown in flutter doctor)

---

## ⏱️ Installation Time

| Method | Time | Difficulty |
|--------|------|------------|
| **Manual (Option 1)** | 10-15 min | Easy |
| **Chocolatey (Option 2)** | 5-10 min | Easy |
| **Package Manager (Option 3)** | 3-5 min | Very Easy |

---

## 🎯 Next Steps After Installation

1. ✓ Verify `flutter doctor` shows no errors
2. ✓ Navigate to your project
3. ✓ Run `flutter build apk --debug`
4. ✓ Find APK in `build/app/outputs/apk/debug/`
5. ✓ Install on Android device
6. ✓ Test all features

---

## 📞 Help

If you get stuck:
- **Flutter Docs**: https://flutter.dev/docs
- **Windows Setup**: https://flutter.dev/docs/get-started/install/windows
- **Troubleshooting**: https://flutter.dev/docs/get-started/install/windows#troubleshooting

---

**Status**: Follow steps above, then you can build APK!  
**Time to APK**: ~30-45 minutes total (including Flutter installation)
