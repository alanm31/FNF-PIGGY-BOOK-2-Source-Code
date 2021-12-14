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

class CreditsPageTwo extends MusicBeatState
{
	public static var leftState:Bool = false;

	var piggyLogo:FlxSprite;
	var willowBG:FlxSprite;

	override function create()
	{
		super.create();
		
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Credits Menu (Page 2)", null);
		#end

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('mainmenu/menuBG', 'piggy'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		willowBG = new FlxSprite(250, 200);
		willowBG.frames = Paths.getSparrowAtlas('bgboppers/willowBG', 'piggy');
		willowBG.animation.addByPrefix('idle', "willow bop", 24);
		willowBG.animation.play('idle');
		willowBG.antialiasing = true;
		willowBG.updateHitbox();
		add(willowBG);

		piggyLogo = new FlxSprite(0, 0);
		piggyLogo.frames = Paths.getSparrowAtlas('mainmenu/piggyLogoAnimated', 'piggy');
		piggyLogo.animation.addByPrefix('bump', "logo bumpin", 24);
		piggyLogo.animation.play('bump');
		piggyLogo.scale.set(0.9, 0.9);
		piggyLogo.antialiasing = true;
		piggyLogo.updateHitbox();
		add(piggyLogo);

		var bgBlackOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlackOverlay.alpha = 0.6;
		bgBlackOverlay.updateHitbox();
		bgBlackOverlay.screenCenter();
		add(bgBlackOverlay);

		var creditsText:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits/creditsTextPage2', 'piggy'));
		creditsText.antialiasing = true;
		creditsText.screenCenter();
		creditsText.updateHitbox();
		add(creditsText);
	}

	override function beatHit()
	{
		super.beatHit();
		
		piggyLogo.animation.play('bump', true);
		willowBG.animation.play('idle', true);
	}

	override function update(elapsed:Float)
	{
		if (controls.LEFT)
		{
			leftState = true;
			FlxG.switchState(new CreditsPageOne());
		}

		if (controls.BACK)
		{
			leftState = true;
			FlxG.sound.music.stop();
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

}
