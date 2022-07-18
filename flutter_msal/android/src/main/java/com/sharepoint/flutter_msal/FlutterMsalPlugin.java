package com.sharepoint.flutter_msal;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

public class FlutterMsalPlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel channel;
    private MethodCallHandlerDelegate methodCallHandler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.shareitsolutions.flutter_msal");
        methodCallHandler = new MethodCallHandlerDelegate(null, flutterPluginBinding.getApplicationContext(), channel);
        channel.setMethodCallHandler(methodCallHandler);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        methodCallHandler = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        methodCallHandler.setActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        methodCallHandler.setActivity(null);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        methodCallHandler.setActivity(binding.getActivity());
    }

    @Override
    public void onDetachedFromActivity() {
        methodCallHandler.setActivity(null);
    }

    @VisibleForTesting
    static final class Methods {
        static final String INITIALIZE = "initialize";
        static final String SIGN_IN = "signIn";
        static final String SIGN_IN_SILENT = "signInSilent";
        static final String SIGN_OUT = "signOut";

        private Methods() {}
    }
}
