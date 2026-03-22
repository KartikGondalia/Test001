# Google Drive Integration Setup Guide

## Overview
The Media Gallery App now syncs photos directly from your Google Drive folder. This guide explains how to set up and use this integration.

## Prerequisites
- Google account
- Google Drive folder for storing photos
- App installed on device

## Step 1: Prepare Your Google Drive Folder

### 1.1 Create or Identify Your Folder
- Go to [Google Drive](https://drive.google.com)
- Create a new folder or select an existing one for your photos
- Name it something meaningful (e.g., "Media Gallery Photos")

### 1.2 Get Your Folder ID
The app comes pre-configured with folder ID: `1YcDiPwL8wdglpOYOgUwQKRFAP8G1cj_e`

If you want to use a different folder:
1. Open your Google Drive folder
2. Look at the URL in your browser: `https://drive.google.com/drive/folders/FOLDER_ID_HERE`
3. Copy the `FOLDER_ID_HERE` part
4. Update the folder ID in the app:
   - Open `lib/screens/home_screen.dart`
   - Find the line: `_googleDriveFolderId = '1YcDiPwL8wdglpOYOgUwQKRFAP8G1cj_e';`
   - Replace with your folder ID
5. Rebuild and deploy the app

## Step 2: Configure Google API Credentials

### 2.1 Create OAuth 2.0 Credentials
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project or create a new one
3. Navigate to "APIs & Services" → "Credentials"
4. Create an OAuth 2.0 Client ID:
   - Application type: Android/iOS (depending on your platform)
   - Follow the platform-specific instructions below

### 2.2 For Android
1. In Google Cloud Console, create an **Android** OAuth 2.0 Client ID
2. You'll need your app's SHA-1 certificate fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
3. Add the package name and SHA-1 fingerprint
4. Download the JSON file and save as `google-services.json`
5. Place in `android/app/` directory

### 2.3 For iOS
1. In Google Cloud Console, create an **iOS** OAuth 2.0 Client ID
2. Add your Bundle ID
3. Download the configuration file
4. Add to Xcode project following Firebase setup guide

## Step 3: Update App Configuration

### 3.1 Firebase Configuration
Make sure your Firebase project has:
1. Firestore database enabled
2. Authentication with Google Sign-In enabled
3. Firestore security rules configured (see section 3.3)

### 3.2 OAuth Scopes
The app requests these scopes:
- `https://www.googleapis.com/auth/drive.readonly` - Read photos from Drive
- `https://www.googleapis.com/auth/drive.file` - Optional file access

### 3.3 Firestore Security Rules
Update your Firestore security rules to allow photo caching:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow all authenticated users to read photos cache
    match /photos_cache/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'your-admin-email@gmail.com';
    }
    
    // Other collections...
    match /videos/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'your-admin-email@gmail.com';
    }
    
    match /admins/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.email == 'your-admin-email@gmail.com';
    }
  }
}
```

Replace `'your-admin-email@gmail.com'` with the actual admin email address.

## Step 4: Using the App

### 4.1 For Regular Users
1. Open the app
2. Sign in with Google account
3. Photos from the Google Drive folder automatically appear in the gallery
4. Tap the refresh button (⟳) to manually sync latest photos

### 4.2 For Admin
1. Sign in with the admin Google account
2. Open Google Drive and go to your photos folder
3. Upload photos to the folder
4. Return to the app and tap the refresh button
5. Photos appear in the gallery automatically
6. A dialog with upload instructions is available (tap "How to Upload?" when no photos exist)

### 4.3 Photo Management
- **View**: Tap any photo to see full size and details
- **Refresh**: Tap the refresh button in the app bar to sync latest changes
- **Delete**: Photos can only be deleted from Google Drive (not in the app)

## Step 5: Troubleshooting

### Photos Not Appearing
1. Make sure you're signed in with the correct Google account
2. Check that photos are actually in your Drive folder
3. Tap the refresh button to force a sync
4. Check internet connection
5. Check Firestore database has "photos_cache" collection with documents

### Authentication Issues
1. Verify OAuth credentials are correctly configured
2. Check that Google Drive API is enabled in Cloud Console
3. Verify the app has permission to access Google Drive
4. Try signing out and back in

### Performance Issues
- The app syncs up to 100 photos per refresh
- Caching in Firestore reduces API calls
- Real-time updates via Firestore StreamBuilder

## Step 6: Advanced Configuration

### 6.1 Change Refresh Interval
The app syncs on app start. To add periodic syncing:

Edit `lib/screens/home_screen.dart`:
```dart
@override
void initState() {
  super.initState();
  _loadGoogleDrivePhotos();
  
  // Optional: Sync every 5 minutes
  Timer.periodic(Duration(minutes: 5), (_) {
    _loadGoogleDrivePhotos();
  });
}
```

### 6.2 Filter Photos
Currently shows all images in the folder. To filter by file type:

Edit `lib/services/google_drive_service.dart`, modify the query in `syncPhotosFromGoogleDrive()`:
```dart
// Show only JPG and PNG files
q: "'$googleDriveFolderId' in parents and (mimeType='image/jpeg' or mimeType='image/png')",
```

### 6.3 Custom Folder Structure
To organize photos in subfolders within your main folder:
1. Create subfolders in your Google Drive folder
2. The app currently shows all images in the main folder
3. To support subfolders, modify the query in `syncPhotosFromGoogleDrive()`

## API Limits & Quotas

### Google Drive API
- **Quota**: 1 billion queries per day (per project)
- **Rate limit**: 1000 queries per 100 seconds per user
- The app is optimized to cache photos in Firestore to minimize API calls

### Firestore
- **Read operations**: 50,000 per day on Spark plan
- **Write operations**: 20,000 per day on Spark plan
- Consider upgrading to Blaze plan for production with >1000 users

## Security Considerations

1. **OAuth Tokens**: Never expose OAuth tokens or API keys in client code
2. **Folder Access**: Only the authenticated user can upload to their Drive
3. **Admin Verification**: Server checks admin email before allowing writes
4. **Firestore Rules**: Always enforce role-based access control
5. **Data Privacy**: Follow GDPR/CCPA compliance for user data

## Support & Issues

For technical support:
1. Check the troubleshooting section above
2. Review the app logs (run in debug mode)
3. Verify Firebase and Google API configuration
4. Check network connectivity

## Next Steps

1. Deploy the app to Google Play and App Store (follow DEPLOYMENT_GUIDE.md)
2. Configure the admin email in Firestore security rules
3. Upload test photos and verify syncing
4. Monitor Firestore and API quotas for your usage patterns
5. Optimize based on user feedback

---

**Last Updated**: 2024
**Version**: 1.0
**Status**: Production Ready
