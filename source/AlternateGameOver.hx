package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class AlternateGameOver extends MusicBeatSubstate
{
	var waitBro:Bool = false;
	var text:FlxSprite;

	public function new(x:Float, y:Float)
	{
		super();

		text = new FlxSprite().loadGraphic(Paths.image('gameover/text', 'piggy'));
		text.antialiasing = true;
		text.setGraphicSize(FlxG.width, FlxG.height);
		text.alpha = 0;
		add(text);

		Conductor.songPosition = 0;

		FlxG.sound.play(Paths.sound('fnf_loss_sfx', 'shared'));
		Conductor.changeBPM(100);

		startZoomAndMusic();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endYoBullshit();
		}

		if (controls.BACK)
		{
			waitBro = false;

			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			
			PlayState.loadRep = false;
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function startZoomAndMusic()
	{
		waitBro = true;

		FlxTween.tween(text, {alpha: 1}, 2);
		FlxTween.tween(FlxG.camera, {zoom: 1.1}, 3, {ease: FlxEase.cubeOut});

		new FlxTimer().start(3.3, function(tmr:FlxTimer)
		{
			waitBro = false;
			FlxG.sound.playMusic(Paths.music('gameOverAlt', 'piggy'), 0.5, true);
		});
	}

	function endYoBullshit():Void
	{
		if (!isEnding && !waitBro)
		{
			waitBro = false;
			isEnding = true;

			FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('gameOverEndAlt', 'piggy'), 0.5, false);
			
			FlxTween.tween(text, {alpha: 0}, 3);

			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
