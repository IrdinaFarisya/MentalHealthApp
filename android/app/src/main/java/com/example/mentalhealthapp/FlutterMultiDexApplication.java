package com.example.mentalhealthapp;

import android.app.Application;
import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class FlutterMultiDexApplication extends MultiDexApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        MultiDex.install(this);
        // This method will configure plugins for the Flutter engine
        FlutterEngine flutterEngine = new FlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
