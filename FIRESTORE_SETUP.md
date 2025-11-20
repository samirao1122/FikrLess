# Firestore Setup Instructions

## Current Issue
Your app is getting permission denied errors because Firestore security rules need to be configured.

## Quick Fix (Development)

1. **Deploy the security rules:**
   - Open Firebase Console: https://console.firebase.google.com/
   - Select your project: `fikrless`
   - Go to **Firestore Database** → **Rules**
   - Copy the contents of `firestore.rules` file
   - Paste and click **Publish**

2. **Create the required index:**
   - The error message provides a direct link to create the index
   - Or go to: https://console.firebase.google.com/v1/r/project/fikrless/firestore/indexes
   - Click the link from the error message, or manually create:
     - Collection: `chatRooms`
     - Fields: 
       - `participants` (Array)
       - `lastMessageTime` (Descending)
     - Query scope: Collection

## Production Security (Recommended)

For production, you should implement proper security rules. Since your app uses custom authentication (not Firebase Auth), you have two options:

### Option 1: Use Firebase Authentication with Custom Tokens
- Generate custom tokens on your backend
- Sign in users with `signInWithCustomToken()`
- Then use `request.auth.uid` in security rules

### Option 2: Validate User IDs in Security Rules
- Store user IDs in a way that can be validated
- Use request data to validate user identity
- This is more complex but works with your current setup

## Current Rules (Development Only)

The current rules allow all read/write access. This is fine for development but **NOT secure for production**.

## Index Creation

The composite index is required for the chat list query. Firebase will automatically create it when you click the link in the error message, or you can create it manually in the Firebase Console.

