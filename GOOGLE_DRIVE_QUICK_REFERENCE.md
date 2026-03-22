# Google Drive Integration - Quick Reference

## ✅ What's Done

### Code Changes
- ✅ `home_screen.dart` - Completely rewritten for Google Drive sync
- ✅ `google_drive_service.dart` - Enhanced with Google Drive API integration  
- ✅ Photo model - Supports Google Drive file IDs
- ✅ Authentication - Uses existing Google Sign-In for Drive access
- ✅ Real-time sync - Firestore cache with StreamBuilder updates

### Documentation
- ✅ `GOOGLE_DRIVE_SETUP.md` - Complete setup guide
- ✅ `GOOGLE_DRIVE_INTEGRATION_SUMMARY.md` - Implementation details

## 🚀 Quick Setup (5 minutes)

### 1. Verify App Structure
```
lib/
  ├── main.dart
  ├── screens/
  │   ├── home_screen.dart ✨ (Updated)
  │   ├── videos_screen.dart
  │   └── info_screen.dart
  ├── services/
  │   ├── google_drive_service.dart ✨ (Updated)
  │   ├── auth_service.dart
  │   └── youtube_service.dart
  ├── models/
  │   ├── photo.dart
  │   └── video.dart
  └── widgets/
      └── common_widgets.dart
```

### 2. Configure Google Drive Folder ID
The app is pre-configured with: **`1YcDiPwL8wdglpOYOgUwQKRFAP8G1cj_e`**

If you want to use a different folder:
- Get your folder ID from Google Drive URL
- Edit `lib/screens/home_screen.dart` line ~35:
  ```dart
  _googleDriveFolderId = 'YOUR_FOLDER_ID_HERE';
  ```
- Rebuild the app

### 3. Verify Google API Configuration

**Firebase**:
- ✅ Firestore database created
- ✅ Google Sign-In enabled
- ⚠️ Need to add OAuth credentials (see below)

**Google Cloud Console**:
- [ ] OAuth 2.0 credentials added for Android
- [ ] OAuth 2.0 credentials added for iOS
- [ ] Google Drive API enabled
- [ ] Folder shared with your Google account

### 4. Update Firestore Security Rules

Go to Firebase Console → Firestore Database → Rules:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow everyone to read photos cache
    match /photos_cache/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'YOUR_EMAIL@gmail.com';
    }
    
    // Videos (for year-wise videos)
    match /videos/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'YOUR_EMAIL@gmail.com';
    }
    
    // Admins collection
    match /admins/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'YOUR_EMAIL@gmail.com';
    }
  }
}
```

Replace `YOUR_EMAIL@gmail.com` with your actual admin email.

### 5. Test the Integration

```bash
# Run the app
flutter run

# In-app testing:
1. Sign in with Google
2. Should show photos from Drive folder
3. Tap refresh button (⟳)
4. Upload new photo to Drive folder
5. Tap refresh again
6. New photo should appear in 10 seconds
```

## 📱 User Flow

### For Everyone
```
Open App
  ↓
Sign In with Google
  ↓
See Photos from Drive
  ↓
Tap Photo to View Full Size
  ↓
Tap Refresh (⟳) for Latest
```

### For Admin
```
Open Google Drive
  ↓
Go to Folder
  ↓
Upload Photos
  ↓
Open App
  ↓
Tap Refresh (⟳)
  ↓
Photos Appear in Gallery
```

## 🔧 How It Works (Technical)

```
1. User opens app & signs in with Google
   └─ OAuth token obtained from Google Sign-In

2. App calls syncPhotosFromGoogleDrive()
   └─ Google Drive API queries folder for images

3. Photos cached in Firestore "photos_cache" collection
   └─ Stores: ID, title, URL, upload date, admin name

4. StreamBuilder listens to Firestore changes
   └─ Real-time updates without API polling

5. UI displays cached photos with Drive image URLs
   └─ https://drive.google.com/uc?id={fileId}&export=view
```

## 📊 Data Structure

### Firestore: photos_cache Collection
```json
Document: "google-drive-file-id"
{
  "driveFileId": "1A2B3C4D5E6F7G8H9I0J",
  "id": "1A2B3C4D5E6F7G8H9I0J",
  "imageUrl": "https://drive.google.com/uc?id=1A2B3C4D5E6F7G8H9I0J&export=view",
  "title": "photo-name.jpg",
  "uploadDate": "2024-01-15T10:30:00Z",
  "uploadedBy": "Admin (Google Drive)"
}
```

## 🆘 Troubleshooting

### Photos Not Showing?
1. **Check**: Are photos actually in the Drive folder?
   - Open Drive → Verify folder has images

2. **Check**: Is app signed in?
   - Sign out and back in

3. **Check**: Did you tap refresh button?
   - Tap the ⟳ button in app bar

4. **Check**: Internet connection?
   - Verify connected to WiFi/mobile data

5. **Check**: Firestore rules?
   - Go to Firebase → Firestore → Rules
   - Verify read access for authenticated users

### Authorization Error?
1. Open Google Cloud Console
2. Go to APIs & Services → Credentials
3. Verify OAuth credentials for your app
4. Check SHA-1 fingerprint matches (Android)
5. Check Bundle ID matches (iOS)

### No Photos Cache Collection?
- App creates "photos_cache" automatically on first sync
- If it doesn't appear, check app logs for errors
- Manually create collection if needed (set to empty for now)

## ⚙️ Configuration Options

### Change Refresh Interval
Edit `lib/screens/home_screen.dart`:
```dart
// Add periodic refresh (sync every 5 minutes)
Timer.periodic(Duration(minutes: 5), (_) {
  _loadGoogleDrivePhotos();
});
```

### Show Only Specific File Types
Edit `lib/services/google_drive_service.dart` in `syncPhotosFromGoogleDrive()`:
```dart
// Only JPG and PNG
q: "'$googleDriveFolderId' in parents and (mimeType='image/jpeg' or mimeType='image/png')",
```

### Limit Photos Displayed
Edit `lib/services/google_drive_service.dart`:
```dart
final fileList = await driveApi.files.list(
  q: "'$googleDriveFolderId' in parents and (mimeType contains 'image/')",
  pageSize: 50,  // Change from 100 to 50
);
```

## 📈 Quota & Limits

### Google Drive API
- Daily quota: 1 billion queries per project
- Rate limit: 1000 queries per 100 seconds per user
- App caches to minimize API calls

### Firestore
- Spark plan: 50K reads + 20K writes per day
- Blaze plan: Pay-as-you-go (recommended for production)

## ✨ Key Features

✅ **Real-time Sync** - Photos update instantly from Drive  
✅ **Admin-Only Upload** - Only admin can manage photos via Drive  
✅ **No In-App Upload** - Eliminates upload complexity  
✅ **Scalable** - Supports 100+ photos per folder  
✅ **Cached** - Uses Firestore cache to reduce API calls  
✅ **Secure** - Firebase authentication & Firestore rules  
✅ **Cross-Platform** - Works on iOS and Android  

## 🚀 Next Steps

1. **Deploy to Devices**
   - Follow DEPLOYMENT_GUIDE.md
   - Test on iOS and Android

2. **Setup Admin Access**
   - Share Drive folder with admin
   - Add admin email to Firestore rules
   - Test photo upload and sync

3. **Monitor Usage**
   - Check Firestore quota in Firebase Console
   - Monitor API calls and errors
   - Upgrade plan if quota exceeded

4. **Launch to App Store**
   - Update privacy policy (mention Drive access)
   - Update app description
   - Build and submit for review

## 📚 Documentation Files

- **GOOGLE_DRIVE_SETUP.md** - Complete setup guide with screenshots
- **GOOGLE_DRIVE_INTEGRATION_SUMMARY.md** - Technical implementation details
- **DEPLOYMENT_GUIDE.md** - Steps to deploy to iOS/Android stores
- **README.md** - App overview and features

## 🎯 Success Criteria

- [ ] App builds without errors
- [ ] Photos from Drive display in gallery
- [ ] New photos appear after refresh
- [ ] Admin upload instructions visible
- [ ] Real-time updates working
- [ ] Works on both iOS and Android
- [ ] Deployed to app stores
- [ ] Users can sign in and see photos

---

**Status**: ✅ Ready for Testing  
**Next**: Deploy to test devices and verify functionality  
**Questions**: Check documentation files above
