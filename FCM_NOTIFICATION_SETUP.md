# FCM Notification Setup Guide

## ⚠️ IMPORTANT: FCM Legacy API is Deprecated!

The FCM Legacy API (which used server keys) is **no longer available**. You must use the **FCM HTTP v1 API**, which requires server-side implementation.

## Current Status ✅

Your app **already has the infrastructure** to receive FCM notifications! Here's what's working:

1. ✅ FCM tokens are saved to Firestore when users log in (`ChatService.saveFCMToken()`)
2. ✅ App can receive notifications (foreground, background, terminated)
3. ✅ Your token is being logged: `eTQK06kMRxeF-Lmf2o-14S:APA91bHw2cbw7qn3ERu_WEbSWYSmQx89AOxoVA7yPl02BFyORVxTkwUGezkrbvxqu2mq9gau4j0fyKcaC_P_aAJks1q3uJ64CkYjKYF1lZyU0czOMxKkAc4`

## ⭐ RECOMMENDED: Firebase Cloud Functions (Easiest & Most Secure)

**See `CLOUD_FUNCTIONS_SETUP.md` for complete step-by-step guide!**

This is the **easiest and most secure** solution. Cloud Functions automatically send notifications when messages are created in Firestore.

---

## Option 1: Client-Side Sending (DEPRECATED - No Longer Works) ❌

**Status:** ❌ **NO LONGER AVAILABLE**

The FCM Legacy API has been deprecated and is no longer available. This option will not work.

**Why it doesn't work:**
- FCM Legacy API required a "Server Key" which is no longer available
- FCM HTTP v1 API requires service account credentials and OAuth2
- Service account credentials should NEVER be stored in client apps

**You must use one of the server-side options below.**

**How it works:**
- User A sends message → `ChatService.sendMessage()` is called
- App gets User B's token from Firestore: `users/{receiverId}/fcmToken`
- App calls `FCMSenderService.sendChatNotification()` with User B's token
- Notification is sent!

---

## Option 2: Firebase Cloud Functions (⭐ RECOMMENDED - See CLOUD_FUNCTIONS_SETUP.md) ⭐

**Pros:**
- ✅ Secure (server key stays on server)
- ✅ No server to maintain (serverless)
- ✅ Recommended by Firebase
- ✅ Free tier available

**Cons:**
- ⚠️ Need to learn Cloud Functions
- ⚠️ Requires Firebase CLI setup

**See `CLOUD_FUNCTIONS_SETUP.md` for complete step-by-step instructions!**

**Quick Overview:**

1. **Install Firebase CLI and initialize:**
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase init functions
   ```

2. **Create the Cloud Function** (`functions/index.js`):
   ```javascript
   const functions = require('firebase-functions');
   const admin = require('firebase-admin');
   admin.initializeApp();

   exports.sendChatNotification = functions.firestore
     .document('chatRooms/{chatRoomId}/messages/{messageId}')
     .onCreate(async (snap, context) => {
       const messageData = snap.data();
       const { senderId, receiverId, message } = messageData;

       // Get receiver's FCM token from Firestore
       const receiverDoc = await admin.firestore()
         .collection('users')
         .doc(receiverId)
         .get();
       
       const fcmToken = receiverDoc.data()?.fcmToken;
       if (!fcmToken) {
         console.log('No FCM token for receiver:', receiverId);
         return null;
       }

       // Get sender's name
       const senderDoc = await admin.firestore()
         .collection('users')
         .doc(senderId)
         .get();
       const senderName = senderDoc.data()?.name || 'Someone';

       // Send notification
       const payload = {
         notification: {
           title: senderName,
           body: message,
           sound: 'default',
         },
         data: {
           type: 'chat_message',
           chatRoomId: context.params.chatRoomId,
           senderId: senderId,
           message: message,
         },
         android: {
           priority: 'high',
           notification: {
             channelId: 'high_importance_channel',
             sound: 'default',
           },
         },
         apns: {
           payload: {
             aps: {
               sound: 'default',
               badge: 1,
             },
           },
         },
         token: fcmToken,
       };

       try {
         await admin.messaging().send(payload);
         console.log('Notification sent successfully');
       } catch (error) {
         console.error('Error sending notification:', error);
       }

       return null;
     });
   ```

4. **Deploy the function:**
   ```bash
   firebase deploy --only functions
   ```

5. **Update your Flutter code** - Remove client-side sending:
   - In `lib/services/chat_service.dart`, comment out the `_sendNotification()` call
   - The Cloud Function will automatically trigger when a message is created!

**How it works:**
- User A sends message → Message saved to Firestore
- Cloud Function automatically triggers (Firestore trigger)
- Function gets receiver's token and sends notification
- **No client-side code needed!**

---

## Option 3: Add Endpoint to Your Existing Backend API 🚀

**Pros:**
- ✅ Uses your existing infrastructure (`https://fikrless.com/api/v1`)
- ✅ Secure (server key on backend)
- ✅ Full control

**Cons:**
- ⚠️ Need to modify your backend
- ⚠️ Need to deploy backend changes

**Setup Steps:**

1. **Add endpoint to your backend** (Node.js/Python/etc.):
   ```javascript
   // Example Node.js endpoint
   POST /api/v1/notifications/send
   {
     "receiverId": "user123",
     "title": "New Message",
     "body": "Hello!",
     "data": {
       "type": "chat_message",
       "chatRoomId": "room123"
     }
   }
   ```

2. **Backend implementation** (Node.js example):
   ```javascript
   const admin = require('firebase-admin');
   const serviceAccount = require('./service-account-key.json');

   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });

   app.post('/api/v1/notifications/send', async (req, res) => {
     const { receiverId, title, body, data } = req.body;
     
     // Get receiver's FCM token from Firestore
     const receiverDoc = await admin.firestore()
       .collection('users')
       .doc(receiverId)
       .get();
     
     const fcmToken = receiverDoc.data()?.fcmToken;
     if (!fcmToken) {
       return res.status(404).json({ error: 'FCM token not found' });
     }

     const message = {
       notification: { title, body },
       data: data || {},
       token: fcmToken,
     };

     try {
       await admin.messaging().send(message);
       res.json({ success: true });
     } catch (error) {
       res.status(500).json({ error: error.message });
     }
   });
   ```

3. **Update Flutter code** - Call your API instead:
   ```dart
   // In ChatService._sendNotification()
   final response = await http.post(
     Uri.parse('https://fikrless.com/api/v1/notifications/send'),
     headers: ApiService.getHeaders(token: authToken),
     body: json.encode({
       'receiverId': receiverId,
       'title': senderName,
       'body': message,
       'data': {
         'type': 'chat_message',
         'chatRoomId': chatRoomId,
         'senderId': senderId,
       },
     }),
   );
   ```

---

## Option 4: Simple Node.js Server (If you don't have backend) 🖥️

**Pros:**
- ✅ Full control
- ✅ Secure
- ✅ Can host on Heroku/Railway/Render (free tiers)

**Cons:**
- ⚠️ Need to deploy and maintain server
- ⚠️ Additional infrastructure

**Quick Setup:**

1. **Create `server.js`:**
   ```javascript
   const express = require('express');
   const admin = require('firebase-admin');
   const serviceAccount = require('./service-account-key.json');

   admin.initializeApp({
     credential: admin.credential.cert(serviceAccount)
   });

   const app = express();
   app.use(express.json());

   app.post('/send-notification', async (req, res) => {
     const { receiverId, title, body, data } = req.body;
     
     const receiverDoc = await admin.firestore()
       .collection('users')
       .doc(receiverId)
       .get();
     
     const fcmToken = receiverDoc.data()?.fcmToken;
     if (!fcmToken) {
       return res.status(404).json({ error: 'Token not found' });
     }

     try {
       await admin.messaging().send({
         notification: { title, body },
         data: data || {},
         token: fcmToken,
       });
       res.json({ success: true });
     } catch (error) {
       res.status(500).json({ error: error.message });
     }
   });

   app.listen(3000, () => console.log('Server running on port 3000'));
   ```

2. **Deploy to free hosting** (Heroku/Railway/Render)

---

## Recommendation 🎯

**For Now (Development/Testing):**
- Use **Option 1** (client-side) - it's already working!
- Just add your FCM Server Key to `fcm_sender_service.dart`

**For Production:**
- Use **Option 2** (Cloud Functions) - most secure and easiest to maintain
- OR **Option 3** if you want to use your existing backend

---

## How Token Flow Works 🔄

1. **User logs in** → `ChatService.initializeFCM(userId)` is called
2. **FCM token is obtained** → `FirebaseMessaging.instance.getToken()`
3. **Token is saved to Firestore** → `users/{userId}/fcmToken`
4. **When User A sends message to User B:**
   - App reads `users/{userB}/fcmToken` from Firestore
   - App sends notification using that token
   - User B receives notification! 🎉

**Your token is already being saved!** You just need to configure the server key for sending.

---

## Testing Your Setup 🧪

1. **Get your FCM Server Key** (see Option 1, Step 1)
2. **Add it to `fcm_sender_service.dart`**
3. **Send a test message:**
   - User A sends message to User B
   - Check logs for: `✅ Chat notification sent to {receiverId}`
   - User B should receive notification!

---

## Troubleshooting 🔧

**"No FCM token found for user"**
- Make sure the user has logged in and `ChatService.initializeFCM()` was called
- Check Firestore: `users/{userId}/fcmToken` should exist

**"FCM Server Key not configured"**
- Add your server key to `fcm_sender_service.dart`

**Notifications not received**
- Check device has internet
- Check notification permissions are granted
- Check FCM token is valid (not expired)

