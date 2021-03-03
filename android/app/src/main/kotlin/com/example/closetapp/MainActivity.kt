package com.example.closetapp

import android.os.Bundle
import io.flutter.app.FlutterActivity
import com.tekartik.sqflite.SqflitePlugin
import io.flutter.plugins.camera.CameraPlugin

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SqflitePlugin.registerWith(registrarFor("com.tekartik.sqflite.SqflitePlugin"))
        CameraPlugin.registerWith(registrarFor("plugins.flutter.io/camera"))
    }
}
