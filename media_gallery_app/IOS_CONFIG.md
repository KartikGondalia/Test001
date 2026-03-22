# iOS Configuration Guide

## Update ios/Podfile

```ruby
# ios/Podfile

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

## Update ios/Runner/Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Media Gallery</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    
    <!-- Camera Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>We need camera access to take and upload photos to the gallery</string>
    
    <!-- Photo Library Permissions -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to your photo library to upload and manage photos</string>
    
    <!-- Location (if needed) -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to tag photos</string>
    
    <!-- Minimum iOS version -->
    <key>MinimumOSVersion</key>
    <string>12.0</string>
    
    <!-- App Support URL -->
    <key>NSBonjourServiceTypes</key>
    <array>
        <string>_http._tcp</string>
    </array>
</dict>
</plist>
```

## Xcode Configuration

1. Open ios/Runner.xcworkspace
2. Select Runner project
3. Target → Runner → General
   - Bundle Identifier: com.example.mediaGalleryApp
   - Version: 1.0
   - Build: 1
   - Minimum Deployment Target: 12.0

4. Target → Runner → Signing & Capabilities
   - Select Team
   - Add capability: Sign in with Apple (optional)
