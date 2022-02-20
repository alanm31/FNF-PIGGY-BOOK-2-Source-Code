package;

// for game shutdown lololololololol
import flash.system.System;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import lime.app.Application;

// unused startup state for when you open the game but this shit didnt work so RIP
class StartupState extends MusicBeatState
{
/*	var gameStarted:Bool = false;
	var isLoading:Bool = false;
	var finishedLoading:Bool = false;
	var startup:Bool = false;

	var loadingText:FlxSprite;
	var skipText:FlxText;

	override function create()
	{
		super.create();
		
		// i demand you to work retard!!!!!!
		gameStarted = true;

		loadingText = new FlxSprite().loadGraphic(Paths.image('bookSelection/loadingText', 'piggy'));
		loadingText.antialiasing = true;
		loadingText.scrollFactor.set();
		loadingText.setGraphicSize(FlxG.width, FlxG.height);
		loadingText.updateHitbox();

		skipText = new FlxText(0, FlxG.height - 65, 0, "Press ENTER to Skip Loading.", 36);
		skipText.setFormat(Paths.font("JAi_____.ttf"), 24, FlxColor.WHITE, LEFT);
		skipText.borderStyle = FlxTextBorderStyle.OUTLINE;
		skipText.borderSize = 2;
		skipText.borderColor = FlxColor.BLACK;
		skipText.screenCenter(X);
		add(skipText);
	}

	function startLoading()
	{
		gameStarted = false;
		isLoading = true;
		add(loadingText);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			startGame();

			finishedLoading = true;
		});
	}

	function startGame()
	{
		isLoading = false;
		finishedLoading = false;
		startup = true;

		remove(skipText);

		new FlxTimer().start(0.001, function(tmr:FlxTimer)
		{
			finishedStartup();
		});
	}

	function finishedStartup()
	{
		remove(loadingText);
		startup = false;

		FlxG.switchState(new BookSelectionState());
	}

	override function update(elapsed:Float)
	{
		if (gameStarted)
		{
			startLoading();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			if (isLoading)
			{
				skipLoading();
			}
		}

		super.update(elapsed);
	}

	function skipLoading()
	{
		isLoading = false;
		finishedLoading = false;
		startup = true;		
		remove(skipText);

		finishedStartup();
	} */
}