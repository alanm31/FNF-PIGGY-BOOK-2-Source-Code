package;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

class CreditsState extends MusicBeatState
{
	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bgs/chapter11/labHallwayBG', 'piggy'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var bgBlackOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0.6;
		bgBlackOverlay.updateHitbox();
		bgBlackOverlay.screenCenter();
		add(bgBlackOverlay);

		var creditsText:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits/creditsText', 'piggy'));
		creditsText.antialiasing = true;
		creditsText.setGraphicSize(FlxG.width, FlxG.height);
		creditsText.screenCenter();
		creditsText.updateHitbox();
		add(creditsText);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
