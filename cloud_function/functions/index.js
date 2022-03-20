const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()
exports.sendNotificationOnCreate = functions.firestore
	.document('{Notifications}/{sessionId}')
	.onCreate((snap, context) => {
		console.log('----------------start function--------------------')
		const doc = snap.data()
		console.log(doc)
		const title = doc.Notifications[doc.Notifications.length - 1].notificationTitle
		console.log(title)
		const body = doc.Notifications[doc.Notifications.length - 1].notificationBody
		console.log(body)
		const sessionId = doc.Notifications[doc.Notifications.length - 1].sessionId
		console.log(sessionId)

		return admin
			.firestore()
			.collection('SessionIdUserFinder')
			.doc(sessionId)
			.get()
			.then(querySnapshot => {
				//console.log(querySnapshot)
				console.log(title)
				console.log(body)
				const payload = {
					notification: {
						title: title,
						body: body,
						badge: '1',
						sound: 'default'
					}
				}
				for (var i = 0; querySnapshot.data().pushTokens.length; i++) {

					admin.messaging().sendToDevice(querySnapshot.data().pushTokens[i].token, payload).then(response => {
						console.log('Successfully sent message:', response)
					})
						.catch(error => {
							console.log('Error sending message:', error)
						})

				}
			})
		return null
	})

exports.sendNotificationOnUpdate = functions.firestore
	.document('{Notifications}/{sessionId}')
	.onUpdate((snap, context) => {
		console.log('----------------start function--------------------')
		const doc = snap.after.data()
		const title = doc.Notifications[doc.Notifications.length - 1].notificationTitle
		console.log(title)
		const body = doc.Notifications[doc.Notifications.length - 1].notificationBody
		console.log(body)
		const sessionId = doc.Notifications[doc.Notifications.length - 1].sessionId
		console.log(sessionId)
		return admin
			.firestore()
			.collection('SessionIdUserFinder')
			.doc(sessionId)
			//.where('sessionId', '==', sessionId)
			.get()
			.then(querySnapshot => {
				//console.log(querySnapshot)
				const payload = {
					notification: {
						title: title,
						body: body,
						badge: '1',
						sound: 'default'
					}
				}
				for (var i = 0; querySnapshot.data().pushTokens.length; i++) {
					if (querySnapshot.data().tokenStatus[querySnapshot.data().pushTokens[i].token]) {
						admin.messaging().sendToDevice(querySnapshot.data().pushTokens[i].token, payload).then(response => {
							console.log('Successfully sent message:', response)
						})
							.catch(error => {
								console.log('Error sending message:', error)
							})
					}

				}
			})
		return null
	})