package it.speedcubing.cube_challenge_timer;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import net.gnehzr.tnoodle.scrambles.Puzzle;
import net.gnehzr.tnoodle.scrambles.ScrambleCacher;

import puzzle.*;


import android.os.AsyncTask;
import android.util.Log;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "it.speedcubing.cube_challenge_timer/scramble";
    private Puzzle puzzle;
    private ScrambleCacher cache;
    private static final String TYPE_222 = "222";
    private static final String TYPE_333 = "333";
    private static final String TYPE_444 = "444";
    private static final String TYPE_555 = "555";
    private static final String TYPE_666 = "666";
    private static final String TYPE_777 = "777";
    private static final String TYPE_MINX = "minx";
    private static final String TYPE_PYRAM = "pyram";
    private static final String TYPE_SKWB = "skwb";
    private static final String TYPE_CLOCK = "clock";
    private static final String TYPE_SQ1 = "sq1";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        SharedPreferences preferences = this.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String puzzleId = preferences.getString("flutter.puzzleId", "333");

        puzzle = getScrambleGenerator(puzzleId);
        cache = new ScrambleCacher(puzzle, 4, false);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {

                if (call.method.equals("scramble")) {
                    new GenerateScrambleAndReturn().execute(result);
                } else if (call.method.equals("changePuzzle")) {
                    puzzle = getScrambleGenerator(call.argument("puzzleId"));
                    cache = new ScrambleCacher(puzzle, 4, false);
                    result.success(true);
                } else {
                    result.notImplemented();
                }
            }
        });
    }


    private class GenerateScrambleAndReturn extends AsyncTask<Result, Void, String> {
        Result result;

        @Override
        protected String doInBackground(Result... r) {
            result = r[0];
            try {
                return cache.newScramble();
            } catch (Exception e) {
                return "An error occured";
            }
        }

        @Override
        protected void onPostExecute(String s) {
            result.success(s);
        }
    }


    private Puzzle getScrambleGenerator(String type) {
        Puzzle puzzle;
        switch (type) {
            case TYPE_222:
                puzzle = new TwoByTwoCubePuzzle();
                break;
            case TYPE_333:
                puzzle = new ThreeByThreeCubePuzzle();
                break;
            case TYPE_444:
                puzzle = new FourByFourCubePuzzle();
                break;
            case TYPE_555:
                puzzle = new CubePuzzle(5);
                break;
            case TYPE_666:
                puzzle = new CubePuzzle(6);
                break;
            case TYPE_777:
                puzzle = new CubePuzzle(7);
                break;
            case TYPE_MINX:
                puzzle = new MegaminxPuzzle();
                break;
            case TYPE_PYRAM:
                puzzle = new PyraminxPuzzle();
                break;
            case TYPE_SKWB:
                puzzle = new SkewbPuzzle();
                break;
            case TYPE_CLOCK:
                puzzle = new ClockPuzzle();
                break;
            case TYPE_SQ1:
                puzzle = new SquareOneUnfilteredPuzzle();
                break;
            default:
                puzzle = new ThreeByThreeCubePuzzle();
                break;
        }
        return puzzle;
    }
}
