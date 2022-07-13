package com.example.flutter_channel_test

import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.util.Log
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.random.Random

private const val METHOD_CHANNEL_NAME = "com.example.flutter_channel_test/testChannel"
private const val EVENT_CHANNEL_NAME = "com.example.flutter_channel_test/testEventChannel"
private const val ACTION_NAME = "testAction"

class MainActivity : FlutterActivity() {

    private val streamHandler = StreamHandler()

    override fun provideFlutterEngine(context: Context) = FlutterEngine(context).apply {
        setUpMethodChannel()
        setUpEventChannel()
    }.also(GeneratedPluginRegistrant::registerWith)

    private fun FlutterEngine.setUpMethodChannel() {
        MethodChannel(dartExecutor, METHOD_CHANNEL_NAME).apply {
            setMethodCallHandler(MethodCallHandler(streamHandler::dispatchEvent))
        }
    }

    private fun FlutterEngine.setUpEventChannel() {
        EventChannel(dartExecutor, EVENT_CHANNEL_NAME).apply {
            setStreamHandler(streamHandler)
        }
    }

    private class MethodCallHandler(
        private val dispatchEvent: (Int) -> Unit
    ) : MethodChannel.MethodCallHandler {
        override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
            when (call.method) {
                ACTION_NAME -> dispatchEvent(Random.nextInt(1, 100))
            }
        }
    }

    private class StreamHandler : EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        fun dispatchEvent(event: Int) {
            eventSink?.success(event)
        }
    }
}
