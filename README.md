# BiomitricWithFlutter

Modelo de utilização e implentação de autenticação com uso de biometria com Flutter


## Configurações nescessárias:


### AndroidManifest.xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example.app">
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<manifest>

### MainActivity

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
override fun configureFlutterEngine(flutterEnginge: FlutterEngine){
GneratePluginRegistrant.registerWith(flutterEnginge)
}
}

### android/app/src/main/res/values/styles.xml


<resources>
  <style name="LaunchTheme" parent="Theme.AppCompat.DayNight"></style>
</resources>


### android/app/src/main/AndroidManifest.xml

<application
<activity android:theme="@style/Theme.AppCompat.DayNight"></activity>
</application>

### info.plist

<key>NSFaceIDUsageDescription</key>
<string>Why is my app authenticating using face id?</string>

### MobX Generator
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch --delete-conflicting-outputs
flutter pub run build_runner clean


 
