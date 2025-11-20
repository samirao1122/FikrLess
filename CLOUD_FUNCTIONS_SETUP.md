# Firebase Cloud Functions Setup for FCM v1 API

## ⚠️ Important: FCM Legacy API is Deprecated

The FCM Legacy API (which used server keys) is **no longer available**. You must use the **FCM HTTP v1 API**, which requires server-side implementation.

## ✅ Recommended Solution: Firebase Cloud Functions

Cloud Functions automatically send notifications when messages are created in Firestore. No client-side code needed!

---

## Step-by-Step Setup

### 1. Install Firebase CLI

```bash
# Install Node.js first (if not installed): https://nodejs.org/
# Then install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login
```

### 2. Initialize Functions in Your Project

```bash
# Navigate to your project root
cd C:\Users\muaus\AndroidStudioProjects\FikrLess1

# Initialize Firebase Functions
firebase init functions

# When prompted:
# - Select "Use an existing project" → Choose "fikrless"
# - Language: JavaScript (or TypeScript if you prefer)
# - ESLint: Yes (recommended)
# - Install dependencies: Yes
```

This creates a `functions/` folder in your project.

### 3. Install Required Dependencies

```bash
cd functions
npm install firebase-admin firebase-functions
```

### 4. Create the Cloud Function

Edit `functions/index.js`:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * Automatically sends FCM notification when a new chat message is created
 * 
 * This function triggers whenever a new message is added to:
 * chatRooms/{chatRoomId}/messages/{messageId}
 */
exports.sendChatNotification = functions.firestore
  .document('chatRooms/{chatRoomId}/messages/{messageId}')
  .onCreate(async (snap, context) => {
    const messageData = snap.data();
    const { senderId, receiverId, message } = messageData;
    const chatRoomId = context.params.chatRoomId;

    console.log(`New message in chat room: ${chatRoomId}`);
    console.log(`Sender: ${senderId}, Receiver: ${receiverId}`);

    // Skip if this is a system message or missing required fields
    if (!senderId || !receiverId || !message) {
      console.log('Missing required fields, skipping notification');
      return null;
    }

    try {
      // Get receiver's FCM token from Firestore
      const receiverDoc = await admin.firestore()
        .collection('users')
        .doc(receiverId)
        .get();

      if (!receiverDoc.exists) {
        console.log(`Receiver ${receiverId} not found in Firestore`);
        return null;
      }

      const receiverData = receiverDoc.data();
      const fcmToken = receiverData?.fcmToken;

      if (!fcmToken) {
        console.log(`No FCM token found for receiver ${receiverId}`);
        return null;
      }

      // Get sender's name from Firestore
      let senderName = 'Someone';
      try {
        const senderDoc = await admin.firestore()
          .collection('users')
          .doc(senderId)
          .get();
        
        if (senderDoc.exists) {
          senderName = senderDoc.data()?.name || senderName;
        }
      } catch (error) {
        console.log('Error fetching sender name:', error);
        // Continue with default name
      }

      // Prepare FCM v1 API message
      const messagePayload = {
        notification: {
          title: senderName,
          body: message.length > 100 ? message.substring(0, 100) + '...' : message,
          sound: 'default',
        },
        data: {
          type: 'chat_message',
          chatRoomId: chatRoomId,
          senderId: senderId,
          receiverId: receiverId,
          message: message,
        },
        android: {
          priority: 'high',
          notification: {
            channelId: 'high_importance_channel',
            sound: 'default',
            priority: 'high',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              alert: {
                title: senderName,
                body: message,
              },
            },
          },
        },
        token: fcmToken,
      };

      // Send notification using FCM v1 API
      const response = await admin.messaging().send(messagePayload);
      
      console.log('✅ Notification sent successfully:', response);
      return null;
    } catch (error) {
      console.error('❌ Error sending notification:', error);
      
      // Don't throw - notification failure shouldn't break chat
      // Log error for debugging
      if (error.code === 'messaging/invalid-registration-token' ||
          error.code === 'messaging/registration-token-not-registered') {
        console.log(`Invalid token for user ${receiverId}, consider removing it from Firestore`);
      }
      
      return null;
    }
  });
```

### 5. Deploy the Function

```bash
# Make sure you're in the project root
cd C:\Users\muaus\AndroidStudioProjects\FikrLess1

# Deploy only functions
firebase deploy --only functions

# Or deploy everything
firebase deploy
```

You'll see output like:
```
✔  Deploy complete!

Function URL: https://us-central1-fikrless.cloudfunctions.net/sendChatNotification
```

### 6. Test the Function

1. **Send a chat message** from your Flutter app
2. **Check Firebase Console**:
   - Go to Firebase Console → Functions
   - You should see the function execution logs
3. **Check the receiver's device** - they should receive the notification!

---

## How It Works

```
User A sends message
  ↓
Message saved to Firestore: chatRooms/{roomId}/messages/{messageId}
  ↓
Cloud Function automatically triggers (Firestore trigger)
  ↓
Function gets receiver's FCM token from Firestore
  ↓
Function sends notification using FCM v1 API
  ↓
User B receives notification! 🎉
```

**No client-side code needed!** The function runs automatically on Firebase's servers.

---

## Update Your Flutter Code

Since Cloud Functions handle notifications automatically, you can **remove or comment out** the client-side sending code:

In `lib/services/chat_service.dart`, the `_sendNotification()` method is already updated to show a warning. The Cloud Function will handle everything automatically!

---

## Monitoring & Debugging

### View Function Logs

```bash
# View real-time logs
firebase functions:log

# View logs for specific function
firebase functions:log --only sendChatNotification
```

### Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `fikrless`
3. Go to **Functions** → **Logs**
4. See real-time execution logs

### Common Issues

**"Permission denied"**
- Make sure Firestore security rules allow the function to read `users` collection
- Add to `firestore.rules`:
  ```javascript
  match /users/{userId} {
    allow read: if true; // Functions can read
  }
  ```

**"Invalid registration token"**
- Token might be expired or invalid
- Function will log this - you can add cleanup logic

**"Function timeout"**
- Default timeout is 60 seconds
- Increase in `functions/index.js`:
  ```javascript
  exports.sendChatNotification = functions
    .runWith({ timeoutSeconds: 120 })
    .firestore.document('chatRooms/{chatRoomId}/messages/{messageId}')
    .onCreate(async (snap, context) => {
      // ... function code
    });
  ```

---

## Cost

Firebase Cloud Functions have a **generous free tier**:
- **2 million invocations/month** free
- **400,000 GB-seconds** compute time free
- **200,000 CPU-seconds** free

For a chat app, you'll likely stay well within the free tier unless you have very high traffic.

---

## Alternative: Backend API Endpoint

If you prefer to use your existing backend at `https://fikrless.com/api/v1`, you can add an endpoint there instead. See `FCM_NOTIFICATION_SETUP.md` for details.

---

## Next Steps

1. ✅ Deploy the Cloud Function
2. ✅ Test by sending a chat message
3. ✅ Verify notification is received
4. ✅ Monitor logs in Firebase Console

That's it! Your notifications will now work automatically using the FCM v1 API. 🎉

