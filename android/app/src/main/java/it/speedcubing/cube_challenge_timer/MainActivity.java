package it.speedcubing.cube_challenge_timer;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import cs.min2phase.Search;
import cs.min2phase.Tools;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "it.speedcubing.cube_challenge_timer/scramble";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Search.init();

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("scramble")) {
          String scrambledCube = Tools.randomCube();
          String scramble = new Search().solution(scrambledCube, 21, 100000000, 0, 0);
          result.success(scramble);
        } else {
          result.notImplemented();
        }
      }
    });
  }
}
