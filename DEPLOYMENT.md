# Realtime Crowd Insights

## Deployment Instructions
The way to deploy an iOS app is through the App Store. Tools like [TestFlight](https://developer.apple.com/testflight/) exist to make Beta testing easier. Still, uploading to the App Store or using TestFlight requires an account that's enrolled in the Apple Developer Program which costs $99 dls a year. As of December 2019, the team does not have an account that's enrolled in such program.

## Current Deployment Instructions

### Simulator
The application can be tested using the Simulator provided by Xcode. To do so, the project must be opened using Xcode. The simulator device can be selected from the upper-left corner. 
![Simulator device selector](https://s3.amazonaws.com/nandovieira/media/react-native-setup/xcode-simulator-physical-device.png)
When the device is selected, click the Play button and the Simulator will launch with the app.

### Using your own device
The application may also be tested using your own device (an iPhone). The device must be using iOS 13.

1. Open Xcode project in a Mac computer.
2. Plug iPhone to the computer using a lightning cable.
3. In the device selector in the upper-left corner, select your own device from the top of the list.
![Select your own device](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/ReSymN6xux5z6QVY_VO02Oum0mzkHBA8sklEawgbD0yGjNUQt51-zqBKjt2T-vKb3xhIkarcaE.png)
4. Unlock the device using passcode, touch ID or face ID.
5. Hit Trust when prompted to Trust This Computer.
![Trust computer](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/JEF4XyhiUCdG4mzTrpyRXUFU8VVoID4P55akzWdT1TBR3WhnlEwPs9qjr3jG_oErUWBo4-0MKH.png)
6. Click the play button on Xcode and the app will launch on the iPhone.

[More information](https://www.twilio.com/blog/2018/07/how-to-test-your-ios-application-on-a-real-device.html)

### Troubleshooting Common Errors

* **Signing Requires a Development Team** - Xcode requires that you've connected a Team to your project in order to run. Go to "General" tab of the Project Settings, open the "Team" menu and select your team, in case you dont have a team, select "Add an Account..." and create one with your Apple ID.
* **Verify the Developer App certificate for your account is trusted on your device.** - Go to Settings > General > Profiles (Settings > General > Device Management on later versions of iOS), and select the Developer App Certificate to trust it.