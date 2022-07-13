# Flutter Event Channel Spike

### Flow
- Floating Action Button on Flutter Widget invokes `testAction` on Method channel - `com.example.flutter_channel_test/testChannel`
- Native(Android) dispatches an event(Radnom Integer) on the event channel - `com.example.flutter_channel_test/testEventChannel`
- Flutter listens to stream of these events and updates texts of multiple widgtes. 
- Multiple stream instances can't be created. If we create multiple stream instances, only the latest one remains active. Stream needs to be shared in some way or the other. This spike uses `Provider`.


### Important Files
- [Android Activity](https://github.com/simararora07/Flutter-Event-Channel-Spike/blob/master/android/app/src/main/kotlin/com/example/flutter_channel_test/MainActivity.kt)
- [Flutter Widget](https://github.com/simararora07/Flutter-Event-Channel-Spike/blob/master/lib/main.dart)

https://user-images.githubusercontent.com/102601236/178691903-fd180f96-0329-47e3-854c-2e4282c96f0d.mov
