# Realtime Crowd Insights

## Deployment Instructions
The way to deploy an iOS app is through the App Store. Tools like [TestFlight](https://developer.apple.com/testflight/) exist to make Beta testing easier. Still, uploading to the App Store or using TestFlight requires an account that's enrolled in the Apple Developer Program which costs $99 dls a year. As of September 2019, the team does not have an account that's enrolled in such program.

## Current Deployment Instructions

##### Simulator
The application can be tested using the Simulator provided by Xcode. To do so, the project must be opened using Xcode. The simulator device can be selected from the upper-left corner. 
![Simulator device selector](https://s3.amazonaws.com/nandovieira/media/react-native-setup/xcode-simulator-physical-device.png)
When the device is selected, click the Play button and the Simulator will launch with the app.

##### Using your own device
The application may also be tested using your own device (an iPhone). The device must be using iOS 13.

1. Open Xcode project in a Mac computer.
1. Plug iPhone to the computer using a lightning cable.
1. In the device selector in the upper-left corner, select your own device from the top of the list.
![Select your own device](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/ReSymN6xux5z6QVY_VO02Oum0mzkHBA8sklEawgbD0yGjNUQt51-zqBKjt2T-vKb3xhIkarcaE.png)
1. Unlock the device using passcode, touch ID or face ID.
1. Click the play button on Xcode and the app will launch on the iPhone.

[More information](https://www.twilio.com/blog/2018/07/how-to-test-your-ios-application-on-a-real-device.html)