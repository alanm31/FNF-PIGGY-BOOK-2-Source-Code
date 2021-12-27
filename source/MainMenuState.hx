package;

// for tio's secret jumpscare lololololololol
import flash.system.System;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];

	var newGaming:FlxText;
	var newGaming2:FlxText;

	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var willowBG:FlxSprite;
	var blackScreen:FlxSprite;
	var tioJumpscare:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('piggyMenu', 'piggy'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('mainmenu/menuBG', 'piggy'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('mainmenu/menuDesat', 'piggy'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);

		willowBG = new FlxSprite(250, 200);
		willowBG.frames = Paths.getSparrowAtlas('bgboppers/willowBG', 'piggy');
		willowBG.animation.addByPrefix('idle', "willow bop", 24);
		willowBG.animation.play('idle');
		willowBG.scrollFactor.x = 0;
		willowBG.scrollFactor.y = 0.10;
		willowBG.antialiasing = true;
		willowBG.updateHitbox();
		add(willowBG);

		var piggyLogo:FlxSprite = new FlxSprite(0, -120);
		piggyLogo.frames = Paths.getSparrowAtlas('mainmenu/piggyLogoAnimated', 'piggy');
		piggyLogo.scrollFactor.x = 0;
		piggyLogo.scrollFactor.y = 0.10;
		piggyLogo.animation.addByPrefix('bump', "logo bumpin", 24);
		piggyLogo.animation.play('bump');
		piggyLogo.scale.set(0.9, 0.9);
		piggyLogo.antialiasing = true;
		piggyLogo.updateHitbox();
		add(piggyLogo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets'); 

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.scale.set(0.7, 0.7);
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			switch (i) // changing menuItems position
			{	
				case 0: // Storymode
			        menuItem.setPosition(240, 240);		
				case 1: // Freeplay
			        menuItem.setPosition(360, 360);	
				case 2: // Options
			        menuItem.setPosition(480, 480);	
			    case 3: // Credits
			        menuItem.setPosition(600, 600);	
			}	
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("JackInput", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		blackScreen = new FlxSprite(-100).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
		blackScreen.scale.set(2, 2);
		blackScreen.screenCenter();
		blackScreen.updateHitbox();
		blackScreen.visible = false;
		add(blackScreen);

		tioJumpscare = new FlxSprite(-100).loadGraphic(Paths.image('secret/tioJumpscare', 'piggy'));
		tioJumpscare.setGraphicSize(Std.int(tioJumpscare.width * 1.1));
		tioJumpscare.updateHitbox();
		tioJumpscare.screenCenter();
		tioJumpscare.antialiasing = true;
		tioJumpscare.visible = false;
		add(tioJumpscare);

		FlxG.sound.cache(Paths.sound('Lights_Shut_off', 'shared'));

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.T)
		{
			FlxG.sound.music.stop();
			blackScreen.visible = true;
			FlxG.sound.play(Paths.sound('Lights_Shut_off', 'shared'));

			new FlxTimer().start(.9, function(tmr:FlxTimer)
				{
					funnyJumpscare();
				});
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
//				if (optionShit[curSelected] == 'discord')
//				{
//					fancyOpenURL("https://www.twitter.com/AlexDaShadow");
//				}
//				else
//				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.camera.shake(0.004, 0.2);
					
					if (FlxG.save.data.flashing)
						FlxG.camera.flash(FlxColor.RED, 0.2);
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							// idk what i am doing but ok ig
							FlxTween.tween(FlxG.camera, {zoom: 1.1}, 2, {ease: FlxEase.expoOut});
							FlxTween.tween(FlxG.camera, {y: FlxG.height}, 1.6, {ease: FlxEase.expoIn});

							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1.3, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
//				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.sound.music.stop();
				FlxG.switchState(new StoryMenuState());

				trace("Story Mode Selected.");

			case 'freeplay':
				FlxG.sound.music.stop();
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected.");

			case 'options':
				FlxG.sound.music.stop();
				FlxG.switchState(new OptionsMenu());

				trace("Options Menu Selected.");

			case 'credits':
				FlxG.sound.music.stop();
				FlxG.switchState(new CreditsState());

				trace("Credits Menu Selected.");
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	function funnyJumpscare()
	{
		tioJumpscare.visible = true;
		FlxG.sound.play(Paths.sound('glitch', 'piggy'), 1, true);
	
		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				shutdownGame();
			});	
	}

   	function shutdownGame()
	{
        System.exit(0);
	}	
}
