package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

import flash.system.System;

#if windows
import Discord.DiscordClient;
#end

#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;

	private var shakeCam:Bool = false;

	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	// some bg variables here cuz yes
	var storeBg:FlxSprite;
	var safePlaceBg:FlxSprite;
	var sewersBg:FlxSprite;
	var portBg:FlxSprite;

    // bg boppers shit variables
	var doggyOfficer:FlxSprite;
	var ponyStore:FlxSprite;
	var zizzyStore:FlxSprite;
	var filipRefinery:FlxSprite;
	var ponyRefinery:FlxSprite;
	var zeeSewers:FlxSprite;
	var zuzySewers:FlxSprite;
	var willowBg:FlxSprite; // the lesbian bitch
	var ponyDocks:FlxSprite; // he got infected for being such an idiot and try to fight back when he knows that he's a weak mf
	var robbyTemple:FlxSprite; // obv not the one with a chainsaw :))))))
	var willowCamp:FlxSprite;
	var ponyCamp:FlxSprite;
	
	// winter holiday shit
	var zeeHoliday:FlxSprite;
	var mimiHoliday:FlxSprite;
	var giraffyHoliday:FlxSprite;
	var ponyHoliday:FlxSprite;
	var christmasTree:FlxSprite;

	// insolence note static shit woooooooooo
	var daStaticInsolence:FlxSprite; // stop freezing the game, bitch

	// inGame shit variables
	var blackScreen2:FlxSprite; // naming it blackScreen2 cuz blackScreen is already used for winter horrorland's intro and im too lazy to remove winter horrorland intro code /e cry
                                // edit: well i did, but... its just to organize myself
	var vignette:FlxSprite;
	var vignetteRed:FlxSprite;	
	var snowOverlay:FlxBackdrop; // idk why i love this sm
	var redOverlay:FlxSprite; // so scary :((((
	var promenadeOverlay:FlxBackdrop; 

	// cam movement on note hit
	var maxCamera:Array<Float>;
	var maxCamera2:Array<Float>; // this is just for run away cuz u can barely notice the movement on this song for some reason
    var maxCamera3:Array<Float>; // fixing camera mov. in most stages

	var fc:Bool = true;

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }

	override public function create()
	{
		// PRELOADING INST AND VOICES
		FlxG.sound.cache(Paths.inst(PlayState.SONG.song));
		FlxG.sound.cache(Paths.voices(PlayState.SONG.song));
		
		// PRELOADING INSOLENCE NOTE SOUND WHEN U MISS AN INSOLENCE EYE NOTE AND ALSO OTHER SOUNDS
		// THIS PRELOAD SHIT ALSO CAN UHHH- TAKE ALOT OF MEMORY SO IDC IF YOUR PC IS A OVEN RN (LIKE MINE)
		FlxG.sound.cache(Paths.sound('insolenceNote', 'piggy'));

		FlxG.sound.cache(Paths.sound('intro1', 'shared'));
		FlxG.sound.cache(Paths.sound('intro2', 'shared'));
		FlxG.sound.cache(Paths.sound('intro3', 'shared'));
		FlxG.sound.cache(Paths.sound('introGo', 'shared'));

		FlxG.sound.cache(Paths.sound('missnote1', 'shared'));
		FlxG.sound.cache(Paths.sound('missnote2', 'shared'));
		FlxG.sound.cache(Paths.sound('missnote3', 'shared'));

		FlxG.sound.cache(Paths.sound('fnf_loss_sfx', 'shared'));

		// PRELOADING MID-SONG EVENTS ASSETS CUZ THE GAME MAY FREEZE WHEN THE GAME TRIES TO LOAD IT
		if (SONG.song.toLowerCase() == 'in-stock')
		{
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'IN-STOCK' ASSETS.");	
		}		

		if (SONG.song.toLowerCase() == 'metal-escape')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(1.2, 1.2);
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);
				
			trace("PRELOADED 'METAL-ESCAPE' ASSETS.");	
		}

		if (SONG.song.toLowerCase() == 'underground')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(1.2, 1.2);
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);
				
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			trace("PRELOADED 'UNDERGROUND' ASSETS.");	
		}

		if (SONG.song.toLowerCase() == 'deep-sea')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(1.2, 1.2);
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);
				
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'DEEP-SEA' ASSETS.");	
		}	

		if (SONG.song.toLowerCase() == 'teleport')
		{
			daStaticInsolence = new FlxSprite(-1350, -70);
			daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
			daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
			daStaticInsolence.animation.play('idle');				
			daStaticInsolence.scale.set(1.2, 1.2);
			daStaticInsolence.cameras = [camHUD];
			daStaticInsolence.alpha = 0.4;
			daStaticInsolence.antialiasing = true;
			daStaticInsolence.updateHitbox();
			daStaticInsolence.visible = false;
			add(daStaticInsolence);

			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);
				
			redOverlay = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
			redOverlay.scale.set(1.9, 1.9);
			redOverlay.antialiasing = true;
			redOverlay.screenCenter(X);
			redOverlay.updateHitbox();
			redOverlay.scrollFactor.set();	
			redOverlay.visible = false;
			add(redOverlay);

			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'TELEPORT' ASSETS.");	
		}	

		if (SONG.song.toLowerCase() == 'sneaky')
		{
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);
				
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);

			trace("PRELOADED 'SNEAKY' ASSETS.");	
		}

		if (SONG.song.toLowerCase() == 'cold-blood')
		{
			blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
			blackScreen2.scale.set(2, 2);
			blackScreen2.antialiasing = true;
			blackScreen2.screenCenter();
			blackScreen2.updateHitbox();
			blackScreen2.scrollFactor.set(1, 0.9);	
			blackScreen2.visible = false;
			add(blackScreen2);
		}

		if (SONG.song.toLowerCase() == 'teleport')
		{
			vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
			vignette.scale.set(1.05, 1.05);
			vignette.updateHitbox();
			vignette.cameras = [camHUD];
			vignette.antialiasing = true;
			vignette.scrollFactor.set(1, 0.9);
			vignette.alpha = 0;
			add(vignette);

			vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
			vignetteRed.scale.set(1.05, 1.05);
			vignetteRed.updateHitbox();
			vignetteRed.cameras = [camHUD];
			vignetteRed.antialiasing = true;
			vignetteRed.scrollFactor.set(1, 0.9);
			vignetteRed.alpha = 0;
			add(vignetteRed);

			trace("PRELOADED 'RUN-AWAY' ASSETS.");	
		}

		if (SONG.song.toLowerCase() == 'promenade')
		{
			promenadeOverlay = new FlxBackdrop(Paths.image('inGame/promenadeOverlay', 'piggy'));
			promenadeOverlay.alpha = 0.15;
			promenadeOverlay.velocity.set(-40, 0);
			promenadeOverlay.cameras = [camHUD];
			promenadeOverlay.visible = false;
			add(promenadeOverlay);

			trace("PRELOADED 'PROMENADE' ASSETS.");	
		}

		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		
		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		switch(SONG.stage)
		{
			case 'alleys':
			{
				defaultCamZoom = 0.75;
                curStage = 'alleys';

				var stagePosX = -700;
				var stagePosY = -520;

				var alleysBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/alleysBG', 'piggy'));
				alleysBg.setGraphicSize(Std.int(alleysBg.width * 1.6));
				alleysBg.updateHitbox();
				alleysBg.antialiasing = true;
				alleysBg.scrollFactor.set(1, 0.9);
				add(alleysBg);

				if (FlxG.save.data.distractions)
					{
						doggyOfficer = new FlxSprite(-74, 300);
						doggyOfficer.frames = Paths.getSparrowAtlas('bgboppers/doggyOfficer', 'piggy');
						doggyOfficer.animation.addByPrefix('idle', "doggy bop", 24);
						doggyOfficer.antialiasing = true;			
						doggyOfficer.scrollFactor.set(1, 0.9);
						doggyOfficer.setGraphicSize(Std.int(doggyOfficer.width * .7));
						doggyOfficer.updateHitbox();
						add(doggyOfficer);
					}		
				
				trace("LOADED 'Alleys' STAGE.");	
			}

			case 'store':
				{
					defaultCamZoom = 0.75;
					curStage = 'store';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					storeBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/storeBG', 'piggy'));
					storeBg.setGraphicSize(Std.int(storeBg.width * 1.6));
					storeBg.updateHitbox();
					storeBg.antialiasing = true;
					storeBg.scrollFactor.set(1, 0.9);
					add(storeBg);
	
					if (FlxG.save.data.distractions)
						{
							ponyStore = new FlxSprite(175, 330);
							ponyStore.frames = Paths.getSparrowAtlas('bgboppers/ponyStore', 'piggy');
							ponyStore.animation.addByPrefix('idle', "pony bop", 24);
							ponyStore.antialiasing = true;			
							ponyStore.scrollFactor.set(1, 0.9);
							ponyStore.setGraphicSize(Std.int(ponyStore.width * .7));
							ponyStore.updateHitbox();
							add(ponyStore);

							zizzyStore = new FlxSprite(1044, 290);
							zizzyStore.frames = Paths.getSparrowAtlas('bgboppers/zizzyStore', 'piggy');
							zizzyStore.animation.addByPrefix('idle', "zizzy bop", 24);
							zizzyStore.antialiasing = true;			
							zizzyStore.scrollFactor.set(1, 0.9);
							zizzyStore.setGraphicSize(Std.int(zizzyStore.width * .7));
							zizzyStore.updateHitbox();

                            zizzyStore.flipX = true;

							add(zizzyStore);							
						}		

					// stupid black screen for in game scary ambience /e dance
					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Store' STAGE.");						
				}	

			case 'refinery':
				{
					defaultCamZoom = 0.75;
					curStage = 'refinery';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var refineryBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/refineryBG', 'piggy'));
					refineryBg.setGraphicSize(Std.int(refineryBg.width * 1.6));
					refineryBg.updateHitbox();
					refineryBg.antialiasing = true;
					refineryBg.scrollFactor.set(1, 0.9);
					add(refineryBg);

					if (FlxG.save.data.distractions)
						{
							ponyRefinery = new FlxSprite(1100, 250);
							ponyRefinery.frames = Paths.getSparrowAtlas('bgboppers/ponyRefinery', 'piggy');
							ponyRefinery.animation.addByPrefix('idle', "pony bop", 24);
							ponyRefinery.antialiasing = true;			
							ponyRefinery.scrollFactor.set(1, 0.9);
							ponyRefinery.setGraphicSize(Std.int(ponyRefinery.width * .7));
							ponyRefinery.updateHitbox();
							add(ponyRefinery);	

							ponyRefinery.flipX = true;					
						}

					trace("LOADED 'Refinery' STAGE.");	
				}		

			case 'safeplace':
				{
					defaultCamZoom = 0.75;
					curStage = 'safeplace';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					safePlaceBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/safePlaceBG', 'piggy'));
					safePlaceBg.setGraphicSize(Std.int(safePlaceBg.width * 1.6));
					safePlaceBg.updateHitbox();
					safePlaceBg.antialiasing = true;
					safePlaceBg.scrollFactor.set(1, 0.9);
					add(safePlaceBg);

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(1.2, 1.2);					
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					trace("LOADED 'Safe Place' STAGE.");
				}		
			case 'sewers':
				{
					defaultCamZoom = 0.75;
					curStage = 'sewers';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					sewersBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/sewersBG', 'piggy'));
					sewersBg.setGraphicSize(Std.int(sewersBg.width * 1.6));
					sewersBg.updateHitbox();
					sewersBg.antialiasing = true;
					sewersBg.scrollFactor.set(1, 0.9);
					add(sewersBg);

					if (FlxG.save.data.distractions)
						{
							zeeSewers = new FlxSprite(0, 270);
							zeeSewers.frames = Paths.getSparrowAtlas('bgboppers/zeeSewers', 'piggy');
							zeeSewers.animation.addByPrefix('idle', "zee bop", 24);
							zeeSewers.antialiasing = true;			
							zeeSewers.scrollFactor.set(1, 0.9);
							zeeSewers.setGraphicSize(Std.int(zeeSewers.width * .8));
							zeeSewers.updateHitbox();
							add(zeeSewers);							

							zuzySewers = new FlxSprite(1044, 290);
							zuzySewers.frames = Paths.getSparrowAtlas('bgboppers/zuzySewers', 'piggy');
							zuzySewers.animation.addByPrefix('idle', "zuzy bop", 24);
							zuzySewers.antialiasing = true;			
							zuzySewers.scrollFactor.set(1, 0.9);
							zuzySewers.setGraphicSize(Std.int(zuzySewers.width * .8));
							zuzySewers.updateHitbox();
							add(zuzySewers);	

							zuzySewers.flipX = true;					
						}
					
					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(1.2, 1.2);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);

					trace("LOADED 'Sewers' STAGE.");
				}	
			case 'factory':
				{
					defaultCamZoom = 0.75;
					curStage = 'factory';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var factoryBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/factoryBG', 'piggy'));
					factoryBg.setGraphicSize(Std.int(factoryBg.width * 1.6));
					factoryBg.updateHitbox();
					factoryBg.antialiasing = true;
					factoryBg.scrollFactor.set(1, 0.9);
					add(factoryBg);

					trace("LOADED 'Factory' STAGE.");
				}	
			case 'port':
				{
					defaultCamZoom = 0.75;
					curStage = 'port';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					portBg = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/portBG', 'piggy'));
					portBg.setGraphicSize(Std.int(portBg.width * 1.6));
					portBg.updateHitbox();
					portBg.antialiasing = true;
					portBg.scrollFactor.set(1, 0.9);
					add(portBg);

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(1.2, 1.2);
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);

					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.1, 1.1);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);

					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Port' STAGE.");
				}		
			case 'ship':
				{
					defaultCamZoom = 0.75;
					curStage = 'ship';
	
					var stagePosX = -700;
					var stagePosY = -520;

					var shipBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/shipBG', 'piggy'));
					shipBg.setGraphicSize(Std.int(shipBg.width * 1.6));
					shipBg.updateHitbox();
					shipBg.antialiasing = true;
					shipBg.scrollFactor.set(1, 0.9);
					add(shipBg);

					if (FlxG.save.data.distractions)
						{
							willowBg = new FlxSprite(400, -80);
							willowBg.frames = Paths.getSparrowAtlas('bgboppers/willowBGShip', 'piggy');
							willowBg.animation.addByPrefix('idle', "willow bop", 24);
							willowBg.antialiasing = true;
							willowBg.scrollFactor.set(1, 0.9);
							willowBg.setGraphicSize(Std.int(willowBg.width * .9));
							willowBg.updateHitbox();
							add(willowBg);											
						}

					trace("LOADED 'Ship' STAGE.");
				}	
			
			case 'docks':
				{
					defaultCamZoom = 0.70;
					curStage = 'docks'; // cocks :troll:
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var docksBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/docksBG', 'piggy'));
					docksBg.setGraphicSize(Std.int(docksBg.width * 1.6));
					docksBg.updateHitbox();
					docksBg.antialiasing = true;
					docksBg.scrollFactor.set(1, 0.9);
					add(docksBg);

					if (FlxG.save.data.distractions)
						{
							ponyDocks = new FlxSprite(1100, 250);
							ponyDocks.frames = Paths.getSparrowAtlas('bgboppers/ponyDocks', 'piggy');
							ponyDocks.animation.addByPrefix('idle', "pony bop", 24);
							ponyDocks.antialiasing = true;			
							ponyDocks.scrollFactor.set(1, 0.9);
							ponyDocks.setGraphicSize(Std.int(ponyDocks.width * .7));
							ponyDocks.updateHitbox();
							add(ponyDocks);	

							ponyDocks.flipX = true;					
						}

					daStaticInsolence = new FlxSprite(-1350, -70);
					daStaticInsolence.frames = Paths.getSparrowAtlas('mainmenu/static', 'piggy');
					daStaticInsolence.animation.addByPrefix('idle', 'static', 24);
					daStaticInsolence.animation.play('idle');				
					daStaticInsolence.scale.set(1.2, 1.2);
					daStaticInsolence.cameras = [camHUD];
					daStaticInsolence.alpha = 0.4;
					daStaticInsolence.antialiasing = true;
					daStaticInsolence.updateHitbox();
					daStaticInsolence.visible = false;
					add(daStaticInsolence);
			
					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
			
					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.05, 1.05);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);
							
					redOverlay = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/redOverlay', 'piggy'));
					redOverlay.scale.set(1.9, 1.9);
					redOverlay.antialiasing = true;
					redOverlay.screenCenter(X);
					redOverlay.updateHitbox();
					redOverlay.scrollFactor.set();	
					redOverlay.visible = false;
					add(redOverlay);
			
					blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);	
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Docks' STAGE.");	
				}

			case 'temple':
				{
					defaultCamZoom = 0.75;
					curStage = 'temple';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var templeBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/templeBG', 'piggy'));
					templeBg.setGraphicSize(Std.int(templeBg.width * 1.6));
					templeBg.updateHitbox();
					templeBg.antialiasing = true;
					templeBg.scrollFactor.set(1, 0.9);
					add(templeBg);

					if (FlxG.save.data.distractions)
						{
							robbyTemple = new FlxSprite(1000, 0);
							robbyTemple.frames = Paths.getSparrowAtlas('bgboppers/robbyTemple', 'piggy');
							robbyTemple.animation.addByPrefix('idle', "robby bop", 24);
							robbyTemple.antialiasing = true;			
							robbyTemple.scrollFactor.set(1, 0.9);
							robbyTemple.setGraphicSize(Std.int(robbyTemple.width * .7));
							robbyTemple.updateHitbox();
							add(robbyTemple);	

							robbyTemple.flipX = true;					
						}

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
							
					blackScreen2 = new FlxSprite(-700, -520).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);	
					blackScreen2.visible = false;
					add(blackScreen2);

					trace("LOADED 'Temple' STAGE.");	
				}

			case 'camp':
				{
					defaultCamZoom = 0.75;
					curStage = 'camp';
	
					var stagePosX = -700;
					var stagePosY = -520;
	
					var campBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/campBG', 'piggy'));
					campBg.setGraphicSize(Std.int(campBg.width * 1.6));
					campBg.updateHitbox();
					campBg.antialiasing = true;
					campBg.scrollFactor.set(1, 0.9);
					add(campBg);

					if (FlxG.save.data.distractions)
						{
							willowCamp = new FlxSprite(-50, 200);
							willowCamp.frames = Paths.getSparrowAtlas('bgboppers/willowCamp', 'piggy');
							willowCamp.animation.addByPrefix('idle', "willow bop", 24);
							willowCamp.antialiasing = true;			
							willowCamp.scrollFactor.set(1, 0.9);
							willowCamp.setGraphicSize(Std.int(willowCamp.width * .8));
							willowCamp.updateHitbox();
							add(willowCamp);	

							ponyCamp = new FlxSprite(1100, 250);
							ponyCamp.frames = Paths.getSparrowAtlas('bgboppers/ponyCamp', 'piggy');
							ponyCamp.animation.addByPrefix('idle', "pony bop", 24);
							ponyCamp.antialiasing = true;			
							ponyCamp.scrollFactor.set(1, 0.9);
							ponyCamp.setGraphicSize(Std.int(ponyCamp.width * .75));
							ponyCamp.updateHitbox();
							add(ponyCamp);	

							ponyCamp.flipX = true;					
						}

					snowOverlay = new FlxBackdrop(Paths.image('inGame/snowOverlay', 'piggy'));
					snowOverlay.alpha = 0.80;
					snowOverlay.velocity.set(450, 450);
					snowOverlay.cameras = [camHUD];
					add(snowOverlay);

					blackScreen2 = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('inGame/blackScreen', 'piggy'));
					blackScreen2.scale.set(2, 2);
					blackScreen2.antialiasing = true;
					blackScreen2.screenCenter();
					blackScreen2.updateHitbox();
					blackScreen2.scrollFactor.set(1, 0.9);
					blackScreen2.visible = false;
					add(blackScreen2);
					
					trace("LOADED 'Camp' STAGE.");	
				}

			case 'lab':
				{
					defaultCamZoom = 0.75;
					curStage = 'lab';
	
					var stagePosX = -700;  
					var stagePosY = -520;
	
					var labBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/labBG', 'piggy'));
					labBg.setGraphicSize(Std.int(labBg.width * 1.7));
					labBg.updateHitbox();
					labBg.antialiasing = true;
					labBg.scrollFactor.set(1, 0.9);
					add(labBg);

					vignette = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignette', 'piggy'));
					vignette.scale.set(1.05, 1.05);
					vignette.updateHitbox();
					vignette.cameras = [camHUD];
					vignette.antialiasing = true;
					vignette.scrollFactor.set(1, 0.9);
					vignette.alpha = 0;
					add(vignette);
			
					vignetteRed = new FlxSprite().loadGraphic(Paths.image('mainmenu/vignetteRED', 'piggy'));
					vignetteRed.scale.set(1.05, 1.05);
					vignetteRed.updateHitbox();
					vignetteRed.cameras = [camHUD];
					vignetteRed.antialiasing = true;
					vignetteRed.scrollFactor.set(1, 0.9);
					vignetteRed.alpha = 0;
					add(vignetteRed);

					trace("LOADED 'Lab' STAGE.");	
				}

			case 'cabin':
				{
					defaultCamZoom = 0.75;
					curStage = 'cabin';
	
					var stagePosX = -700;  
					var stagePosY = -520;
	
					var cabinBg:FlxSprite = new FlxSprite(stagePosX, stagePosY).loadGraphic(Paths.image('bgs/winterHoliday/cabinBG', 'piggy'));
					cabinBg.setGraphicSize(Std.int(cabinBg.width * 1.7));
					cabinBg.updateHitbox();
					cabinBg.antialiasing = true;
					cabinBg.scrollFactor.set(1, 0.9);
					add(cabinBg);

					if (FlxG.save.data.distractions)
						{
							mimiHoliday = new FlxSprite(-300, 247);
							mimiHoliday.frames = Paths.getSparrowAtlas('bgboppers/mimiHoliday', 'piggy');
							mimiHoliday.animation.addByPrefix('idle', "mimiholiday bop", 24);
							mimiHoliday.antialiasing = true;			
							mimiHoliday.scrollFactor.set(1, 0.9);
							mimiHoliday.updateHitbox();
							add(mimiHoliday);

							zeeHoliday = new FlxSprite(-150, 290);
							zeeHoliday.frames = Paths.getSparrowAtlas('bgboppers/zeeHoliday', 'piggy');
							zeeHoliday.animation.addByPrefix('idle', "zeeholiday bop", 24);
							zeeHoliday.antialiasing = true;			
							zeeHoliday.scrollFactor.set(1, 0.9);
							zeeHoliday.updateHitbox();
							add(zeeHoliday);

							giraffyHoliday = new FlxSprite(1477, 80);
							giraffyHoliday.frames = Paths.getSparrowAtlas('bgboppers/giraffyHoliday', 'piggy');
							giraffyHoliday.animation.addByPrefix('idle', "giraffyholiday bop", 24);
							giraffyHoliday.antialiasing = true;			
							giraffyHoliday.scrollFactor.set(1, 0.9);
							giraffyHoliday.updateHitbox();
							add(giraffyHoliday);

							giraffyHoliday.flipX = true;

							ponyHoliday = new FlxSprite(1800, 270);
							ponyHoliday.frames = Paths.getSparrowAtlas('bgboppers/ponyHoliday', 'piggy');
							ponyHoliday.animation.addByPrefix('idle', "ponyholiday bop", 24);
							ponyHoliday.antialiasing = true;			
							ponyHoliday.scrollFactor.set(1, 0.9);
							ponyHoliday.updateHitbox();
							add(ponyHoliday);	

							ponyHoliday.flipX = true;					
						}

					christmasTree = new FlxSprite(200, -600);
					christmasTree.frames = Paths.getSparrowAtlas('bgs/winterHoliday/christmasTree', 'piggy');
					christmasTree.animation.addByPrefix('idle', "tree", 24);
					christmasTree.antialiasing = true;
					christmasTree.scale.set(1.4, 1.4);	
					// christmasTree.screenCenter();		
					christmasTree.scrollFactor.set(1, 0.9);
					christmasTree.updateHitbox();
					add(christmasTree);

					promenadeOverlay = new FlxBackdrop(Paths.image('inGame/promenadeOverlay', 'piggy'));
					promenadeOverlay.alpha = 0.15;
					promenadeOverlay.velocity.set(-40, 0);
					promenadeOverlay.cameras = [camHUD];
					promenadeOverlay.visible = false;
					add(promenadeOverlay);

					trace("LOADED 'Cabin' STAGE.");	
				}
		}

		var gfVersion:String = 'nogf';

		switch (SONG.gfVersion)
		{
			default:
				gfVersion = 'nogf';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'nogf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case 'rash':
				camPos.x += 400;
				dad.y += 60;
			case 'dessa':
				camPos.x += 400;
				dad.y += 100;	
			case 'tigry':
				camPos.x += 400;
				dad.x += 40;
				dad.y += 60;
			case 'raze':
				camPos.x += 400;
				dad.y += 60;	
		    case 'alfis':
				camPos.x += 400;
				dad.y += 60;	
			case 'willow':
				camPos.x += 400;
				dad.y += 60;
			case 'dakoda':
				camPos.x += 400;
				dad.y += 60;
			case 'archie':
				camPos.x += 400;
				dad.y += 60;
			case 'markus':
				camPos.x += 400;
				dad.y += 60;	
			case 'spidella':
				camPos.x += 400;
				dad.y += 60;
			case 'delta':
				camPos.x += 400;
				dad.y += 60;	
			case 'penny':
				camPos.x += 400;
				dad.y += 60;
			case 'zizzyholiday':
				camPos.x += 400;
				dad.y += 60;																			
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'alleys':
				boyfriend.y -= 160;
			case 'store':
				boyfriend.y -= 160;		
			case 'refinery':
				boyfriend.y -= 160;		
				dad.y += 90;
			case 'safeplace':
				boyfriend.y -= 270;	
			case 'sewers':
				boyfriend.y -= 160;			
			case 'factory':
				boyfriend.y -= 380;	
				dad.y -= 300;
			case 'port':
				boyfriend.y -= 160;
			case 'ship':
				boyfriend.y -= 280;	
				dad.y -= 210;	
			case 'docks':
				boyfriend.y -= 160;
			case 'temple':
				boyfriend.y -= 500;	
				dad.y -= 320;
			case 'camp':
				boyfriend.y -= 160;		
			case 'lab':
				dad.y -= 300;
				dad.x -= 300;
				boyfriend.y -= 100;	
				boyfriend.x += 350;	
			case 'cabin':
				boyfriend.y -= 160;	
				boyfriend.x += 420;		
				dad.x -= 70;											
		}

		add(gf);

		// BG Layering Shitty Code

	    // no

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :( // you should :troll: -Alex
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				 
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		switch (SONG.song.toLowerCase()) // setting health bar colours for every song
		{
			case 'on-the-hunt': // chapter 1
			{
				healthBar.createFilledBar(0xFF808080, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
			case 'in-stock': // chapter 2
			{
				healthBar.createFilledBar(0xFF30D5C8, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
			case 'intruders': // chapter 3
			{
				healthBar.createFilledBar(0xFFFFA500, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}			
			case 'metal-escape': // chapter 4
			{
				healthBar.createFilledBar(0xFF964B00, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}		
			case 'underground': // chapter 5
			{
				healthBar.createFilledBar(0xFF006400, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
			case 'change': // chapter 6
			{
				healthBar.createFilledBar(0xFFCA1F7B, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}
			case 'deep-sea': // chapter 7
			{
				healthBar.createFilledBar(0xFF9B870C, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}		
			case 'all-aboard': // chapter 8
			{
				healthBar.createFilledBar(0xFFCC5500, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
		    case 'teleport': // chapter 9
			{
				healthBar.createFilledBar(0xFF964B00, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
			case 'sneaky': // chapter 10
			{
				healthBar.createFilledBar(0xFF171716, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}
			case 'cold-blood': // chapter 11
			{
				healthBar.createFilledBar(0xFFE5E4DB, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}		
			case 'run-away': // chapter 12
			{
				healthBar.createFilledBar(0xFFB13B5B, 0xFF808080);
				trace("GENERATED HEALTH BAR.");
			}	
			case 'promenade': // winter holiday
			{
				healthBar.createFilledBar(0xFFB80F0A, 0xFF0B6623);
				trace("GENERATED HEALTH BAR.");
			}	
			default: // in case it doesn't find the song for some reason hjfhihixgfhd (to prevent crashes)
			{
				//                       purple color  blue color (dad & bf)
				healthBar.createFilledBar(0xFF8A36D2, 0xFF2A9DF4);
				trace("GENERATED DEFAULT HEALTH BAR.");
			}							
		}
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		if(FlxG.save.data.botplay) scoreTxt.x = FlxG.width / 2 - 20;													  
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("JAi_____.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		// stay mad -Alex
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("JAi_____.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.botPlay) // kade you forgor about this :skull:
		{
			botPlayState.cameras = [camHUD];
		}
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				default:
					trace("starting countdown..");
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					trace("starting countdown..");
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		// pre lowercasing the song name (schoolIntro)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		if (songLowercase == 'roses' || songLowercase == 'thorns')
		{
			remove(black);

			if (songLowercase == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (songLowercase == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					trace("starting countdown..");
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		remove(gf);
		trace("JUST ALEX. (haha funni monika reference)");

		// putting this here cuz apparently the game wasn't fucking adding them so i had to do it manually
		add(dad);
		add(boyfriend);

		if (SONG.song.toLowerCase() == 'run-away')
		{                
			boyfriend.scale.set(2.3, 2.3);

			trace("big player.");
		}

		generateStaticArrows(0);
		generateStaticArrows(1);

		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("JAi_____.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end

		trace("starting song..");
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// pre lowercasing the song name (generateSong)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
			switch (songLowercase) {
				case 'dad-battle': songLowercase = 'dadbattle';
				case 'philly-nice': songLowercase = 'philly';
			}
		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
					if (daStrumTime < 0)
						daStrumTime = 0;
					var daNoteData:Int = Std.int(songNotes[1] % 4);
 
					var gottaHitNote:Bool = section.mustHitSection;
 
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
 
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
 
					var daType = songNotes[3];
					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
					swagNote.sustainLength = songNotes[2];
 
					swagNote.scrollFactor.set(0, 0);	
 
				var susLength:Float = swagNote.sustainLength;
 
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
 
				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
 
					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
 
					sustainNote.mustPress = gottaHitNote;
 
					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
 
				swagNote.mustPress = gottaHitNote;
 
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		if (shakeCam)
			{
				FlxG.camera.shake(0.005, 0.10);
			}

		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

            // deleted stupid and unecessary secret pause menu chance where u can't go back to your paused game and have to start over again, i hope that gets deleted on fnf :)

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter) // repositioning penny for stupid perspective on run away
				{
					case 'penny':
						camFollow.x = dad.getMidpoint().x + 165;
						camFollow.y = dad.getMidpoint().y + 20;
				}

				// cam move shit
				maxCamera = [camFollow.x - 25, camFollow.y + 25, camFollow.y - 25, camFollow.x + 25];

				// this is just for run away cuz u can barely notice the movement on this song for some reason
				maxCamera2 = [camFollow.x - 175, camFollow.y + 175, camFollow.y - 175, camFollow.x + 175];

				// fix for most of songs (basically does the same thing as maxCamera2 but in reverse)
				maxCamera3 = [camFollow.x - 4, camFollow.y + 4, camFollow.y - 4, camFollow.x + 4];

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage) // repositioning bf for stupid perspective on run away
				{
					case 'lab':
						camFollow.x = boyfriend.getMidpoint().x - 420;
						camFollow.y = boyfriend.getMidpoint().y - 460;
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			if (curStage.startsWith('cabin'))
			{
				trace("we do a little trollin'");
				System.exit(0);
			}
				
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
		}

 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					if (curStage.startsWith('cabin'))
					{
						trace("we do a little trollin'");
						System.exit(0);
					}
					
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + altAnim, true);
								camFollow.y = (maxCamera[2]);

								if (dad.curCharacter == 'penny') // this is just for run away cuz u can barely notice the movement on this song for some reason
								{
									camFollow.y = (maxCamera2[2]);
								}
								if (curStage.startsWith('safeplace'))
								{
									camFollow.y = (maxCamera3[2]);
								}
								if (curStage.startsWith('factory'))
								{
									camFollow.y = (maxCamera3[2]);
								}
								if (curStage.startsWith('port'))
								{
									camFollow.y = (maxCamera3[2]);
								}
								if (curStage.startsWith('ship'))
								{
									camFollow.y = (maxCamera3[2]);
								}
								if (curStage.startsWith('temple'))
								{
									camFollow.y = (maxCamera3[2]);
								}
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
								camFollow.y = (maxCamera[3]);	

								if (dad.curCharacter == 'penny') // this is just for run away cuz u can barely notice the movement on this song for some reason
								{
									camFollow.y = (maxCamera2[3]);
								}
								if (curStage.startsWith('safeplace'))
								{
									camFollow.y = (maxCamera3[3]);
								}
								if (curStage.startsWith('factory'))
								{
									camFollow.y = (maxCamera3[3]);
								}
								if (curStage.startsWith('port'))
								{
									camFollow.y = (maxCamera3[3]);
								}
								if (curStage.startsWith('ship'))
								{
									camFollow.y = (maxCamera3[3]);
								}
								if (curStage.startsWith('temple'))
								{
									camFollow.y = (maxCamera3[3]);
								}
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
								camFollow.y = (maxCamera[1]);

								if (dad.curCharacter == 'penny') // this is just for run away cuz u can barely notice the movement on this song for some reason
								{
									camFollow.y = (maxCamera2[1]);
								}
								if (curStage.startsWith('safeplace'))
								{
									camFollow.y = (maxCamera3[1]);
								}
								if (curStage.startsWith('factory'))
								{
									camFollow.y = (maxCamera3[1]);
								}
								if (curStage.startsWith('port'))
								{
									camFollow.y = (maxCamera3[1]);
								}
								if (curStage.startsWith('ship'))
								{
									camFollow.y = (maxCamera3[1]);
								}
								if (curStage.startsWith('temple'))
								{
									camFollow.y = (maxCamera3[1]);
								}
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);	
								camFollow.y = (maxCamera[0]);

								if (dad.curCharacter == 'penny') // this is just for run away cuz u can barely notice the movement on this song for some reason
								{
									camFollow.y = (maxCamera2[0]);
								}
								if (curStage.startsWith('safeplace'))
								{
									camFollow.y = (maxCamera3[0]);
								}
								if (curStage.startsWith('factory'))
								{
									camFollow.y = (maxCamera3[0]);
								}
								if (curStage.startsWith('port'))
								{
									camFollow.y = (maxCamera3[0]);
								}
								if (curStage.startsWith('ship'))
								{
									camFollow.y = (maxCamera3[0]);
								}
								if (curStage.startsWith('temple'))
								{
									camFollow.y = (maxCamera3[0]);
								}
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (daNote.noteType == 2)
									{
										health -= 0.075;
										vocals.volume = 0;

										daStaticInsolence.visible = true;
										FlxG.sound.play(Paths.sound('insolenceNote', 'piggy'), 1.3);

										new FlxTimer().start(.38, function(tmr:FlxTimer)
										{
											daStaticInsolence.visible = false;
										});
									}
								if (daNote.noteType == 1 || daNote.noteType == 0)
									{
										health -= 0.075;
										vocals.volume = 0;
										if (theFunne)
											noteMiss(daNote.noteData, daNote);
									}
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('piggyMenu', 'piggy'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					
					FlxG.switchState(new StoryMenuState());

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
//					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

//					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);					

					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					FlxG.switchState(new LoadingState(new PlayState(), false)); // i swear i forgot i had to make the first "function new" in LoadingState.hx public to make this work-
						                                                        // since it was private so PlayState.hx couldn't have access to it-
				}
			}
			else
			{
				trace('WENT BACK TO THE DEEPEST PART OF DEEZ NUTS???!!!??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}

	// end deez nuts
	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	// pop up deez nuts
	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				// shit on deez nuts
					case 'shit':
						if (daNote.noteType == 2)
							{
								daStaticInsolence.visible = true;
								FlxG.sound.play(Paths.sound('insolenceNote', 'piggy'), 1.3);

								new FlxTimer().start(.38, function(tmr:FlxTimer)
								{
									daStaticInsolence.visible = false;
								});
								health -= 0.1;
							}
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								score = -300;
								combo = 0;
								misses++;
								health -= 0.2;
								ss = false;
								shits++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.25;
							}

					// be bad with deez nuts
					case 'bad':
						if (daNote.noteType == 2)
							{
								daStaticInsolence.visible = true;
								FlxG.sound.play(Paths.sound('insolenceNote', 'piggy'), 1.3);

								new FlxTimer().start(.38, function(tmr:FlxTimer)
								{
									daStaticInsolence.visible = false;
								});
								health -= 0.075;
							}
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								daRating = 'bad';
								score = 0;
								health -= 0.06;
								ss = false;
								bads++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.50;
							}
					// you are pretty good with deez nuts
					case 'good':
						if (daNote.noteType == 2)
							{
								health -= 0;
							}
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								daRating = 'good';
								score = 200;
								ss = false;
								goods++;
								if (health < 2)
									health += 0.04;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.75;
							}
					// you do sick things with deez nuts
					case 'sick':
						if (daNote.noteType == 2)
							{
								health -= 0;
							}
						if (daNote.noteType == 1 || daNote.noteType == 0)
							{
								if (health < 2)
									health += 0.1;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 1;
								sicks++;	
							}					
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			// should be called prision instead of school, since school irl is called prision
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
					var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
					
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (!directionsAccounted[daNote.noteData])
							{
								if (directionList.contains(daNote.noteData))
								{
									directionsAccounted[daNote.noteData] = true;
									for (coolNote in possibleNotes)
									{
										if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
										{ // if it's the same note twice at < 10ms distance, just delete it
											// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
											dumbNotes.push(daNote);
											break;
										}
										else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
										{ // if daNote is earlier than existing note (coolNote), replace
											possibleNotes.remove(coolNote);
											possibleNotes.push(daNote);
											break;
										}
									}
								}
								else
								{
									possibleNotes.push(daNote);
									directionList.push(daNote.noteData);
								}
							}
						}
					});

					trace('\nCURRENT LINE:\n' + directionsAccounted);
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.playAnim('idle');
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
							camFollow.y = (maxCamera[2]);

							if (boyfriend.curCharacter == 'bfperspective') // this is just for run away cuz u can barely notice the movement on this song for some reason
							{
								camFollow.y = (maxCamera2[2]);
							}
							if (curStage.startsWith('safeplace'))
							{
								camFollow.y = (maxCamera3[2]);
							}
							if (curStage.startsWith('factory'))
							{
								camFollow.y = (maxCamera3[2]);
							}
							if (curStage.startsWith('port'))
							{
								camFollow.y = (maxCamera3[2]);
							}
							if (curStage.startsWith('ship'))
							{
								camFollow.y = (maxCamera3[2]);
							}
							if (curStage.startsWith('temple'))
							{
							    camFollow.y = (maxCamera3[2]);
							}
						case 3:
							boyfriend.playAnim('singRIGHT', true);
							camFollow.y = (maxCamera[0]);

							if (boyfriend.curCharacter == 'bfperspective') // this is just for run away cuz u can barely notice the movement on this song for some reason
							{
								camFollow.y = (maxCamera2[0]);
							}
							if (curStage.startsWith('safeplace'))
							{
								camFollow.y = (maxCamera3[0]);
							}
							if (curStage.startsWith('factory'))
							{
								camFollow.y = (maxCamera3[0]);
							}
							if (curStage.startsWith('port'))
							{
								camFollow.y = (maxCamera3[0]);
							}
							if (curStage.startsWith('ship'))
							{
								camFollow.y = (maxCamera3[0]);
							}
							if (curStage.startsWith('temple'))
							{
							    camFollow.y = (maxCamera3[0]);
							}
						case 1:
							boyfriend.playAnim('singDOWN', true); 
							camFollow.y = (maxCamera[1]);

							if (boyfriend.curCharacter == 'bfperspective') // this is just for run away cuz u can barely notice the movement on this song for some reason
							{
								camFollow.y = (maxCamera2[1]);
							}
							if (curStage.startsWith('safeplace'))
							{
								camFollow.y = (maxCamera3[1]);
							}
							if (curStage.startsWith('factory'))
							{
								camFollow.y = (maxCamera3[1]);
							}
							if (curStage.startsWith('port'))
							{
								camFollow.y = (maxCamera3[1]);
							}
							if (curStage.startsWith('ship'))
							{
								camFollow.y = (maxCamera3[1]);
							}
							if (curStage.startsWith('temple'))
							{
							    camFollow.y = (maxCamera3[1]);
							}
						case 0:
							boyfriend.playAnim('singLEFT', true);
							camFollow.y = (maxCamera[3]);	
							
							if (boyfriend.curCharacter == 'bfperspective') // this is just for run away cuz u can barely notice the movement on this song for some reason
							{
								camFollow.y = (maxCamera2[3]);
							}	
							if (curStage.startsWith('safeplace'))
							{
								camFollow.y = (maxCamera3[3]);
							}
							if (curStage.startsWith('factory'))
							{
								camFollow.y = (maxCamera3[3]);
							}
							if (curStage.startsWith('port'))
							{
								camFollow.y = (maxCamera3[3]);
							}
							if (curStage.startsWith('ship'))
							{
								camFollow.y = (maxCamera3[3]);
							}
							if (curStage.startsWith('temple'))
							{
							    camFollow.y = (maxCamera3[3]);
							}					
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// this shit here only controls the multiple white flashes mid song, nothing else, go more down till override function beatHit() to see other mid song events
		// and more down there's the functions which they make the events work

		if (curSong.toLowerCase() == 'on-the-hunt' && FlxG.save.data.flashing)
			{
				switch (curStep)
				{
					case 128 | 256 | 384 | 512 | 640 | 768:
						camHUD.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong.toLowerCase() == 'in-stock' && FlxG.save.data.flashing)
			{
				switch (curStep)
				{
					case 256 | 384:
						camHUD.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong.toLowerCase() == 'intruders' && FlxG.save.data.flashing)
			{
				switch (curStep)
				{
					case 256 | 384 | 640 | 768 | 784 | 800 | 816 | 832 | 848 | 864 | 880 | 896:
						camHUD.flash(FlxColor.WHITE, 0.5);
				}
			}

		if (curSong.toLowerCase() == 'metal-escape' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 50 | 57 | 59 | 61 | 63 | 184 | 186 | 188 | 190 | 313 | 315 | 317 | 319:
						daStaticInsolence.visible = true;
					case 54 | 58 | 60 | 62 | 64 | 185 | 187 | 189 | 191 | 314 | 316 | 318 | 320:
						daStaticInsolence.visible = false;
					case 440 | 442 | 444 | 446 | 448 | 572 | 574:
						daStaticInsolence.visible = true;
					case 441 | 443 | 445 | 447 | 449 | 573 | 575:
						daStaticInsolence.visible = false;	
				}
			}	

		if (curSong.toLowerCase() == 'teleport' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 59 | 61 | 63:
						blackScreenAppear();
					case 60 | 62 | 64:
						blackScreenRemove();
					case 119:
						defaultCamZoom = 1;
						FlxTween.tween(vignette, {alpha: 1}, 0.1);
					case 128:
						defaultCamZoom = 0.70;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);	
					case 248:
						blackScreenAppear();
						defaultCamZoom = 1;
						FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);	
					case 256:
						blackScreenRemove();	
						camGame.shake(0.003, 7);
					case 320:		
						defaultCamZoom = 0.70;
						FlxTween.tween(vignetteRed, {alpha: 0}, 0.1);
					case 374:
						dad.visible = false;
						boyfriend.visible = false;
						camHUD.visible = false;
						redOverlay.visible = true;
					case 375:
						blackScreenAppear();
						redOverlay.visible = false;
					case 416 | 800:
						blackScreenRemove();
						redOverlay.visible = false;
						camHUD.flash(FlxColor.WHITE, 0.3);
					case 672 | 696 | 724 | 769 | 771 | 1185:
						blackScreenAppear();
					case 695 | 723 | 768 | 770 | 1184:
						blackScreenRemove();
						dad.visible = false;
						boyfriend.visible = false;
						camHUD.visible = false;
						redOverlay.visible = true;
					case 928:	
						camGame.shake(0.003, 7);
				}
			}	

		if (curSong.toLowerCase() == 'sneaky' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256:
						camHUD.flash(FlxColor.WHITE, 0.3);
					case 284:
						defaultCamZoom = 1;
						FlxTween.tween(vignette, {alpha: 1}, 0.1);
					case 512:
						defaultCamZoom = 0.75;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);
					case 768 | 800 | 832 | 864:
						defaultCamZoom = 1;
					case 784 | 816 | 848 | 880:
					    defaultCamZoom = 0.75;
					case 928:
						blackScreenAppear();
				}
			}

		if (curSong.toLowerCase() == 'cold-blood' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256 | 639:
						defaultCamZoom = 1;
					case 383:
						defaultCamZoom = 0.75;
					case 768:
						defaultCamZoom = 0.75;
						snowOverlay.visible = false;
						camHUD.visible = false;
						blackScreenAppear();					
				}
			}

		if (curSong.toLowerCase() == 'run-away' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 256 | 960:	
						defaultCamZoom = 1.1;			
						FlxTween.tween(vignette, {alpha: 1}, 0.35);	
					case 319 | 1023:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.35);
					case 416 | 1120:
						defaultCamZoom = 0.86;
						FlxTween.tween(vignette, {alpha: 1}, 3);
					case 424 | 1128:
						defaultCamZoom = 0.96;
					case 432 | 1136:
						defaultCamZoom = 1.06;
					case 440 | 1144:
						defaultCamZoom = 1.16;
					case 444 | 1148:
						defaultCamZoom = 1.26;
					case 447 | 1151:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.1);
					case 576 | 1280:
						defaultCamZoom = 0.96;
						camHUD.flash(FlxColor.RED, 0.3);
						FlxTween.tween(vignetteRed, {alpha: 1}, 0.01);
						camGame.shake(0.003, 15);
					case 704:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignetteRed, {alpha: 0}, 1.7);
					case 1408:
						defaultCamZoom = 0.76;
						FlxTween.tween(vignette, {alpha: 0}, 0.01);
						FlxTween.tween(vignetteRed, {alpha: 0}, 0.01);
						camHUD.flash(FlxColor.RED, 0.3);
					case 1423:
						FlxTween.tween(camHUD, {alpha: 0}, 0.01);
						FlxG.camera.fade(FlxColor.BLACK, 0.01, false);
				}
			}

		if (curSong.toLowerCase() == 'promenade' && FlxG.save.data.distractions)
			{
				switch (curStep)
				{
					case 120 | 760:
						defaultCamZoom = 1;
					case 128:
						defaultCamZoom = 0.75;
					case 256 | 640 | 896:
					    FlxTween.tween(promenadeOverlay, {alpha: 0}, 2);
					case 320 | 512 | 960:
						FlxTween.tween(promenadeOverlay, {alpha: 0.25}, 0.1);
						camHUD.flash(FlxColor.WHITE, 0.35);
					case 384 | 1024:
					    FlxTween.tween(promenadeOverlay, {alpha: 0}, 1);
					case 768:
						FlxTween.tween(promenadeOverlay, {alpha: 0.25}, 0.1);
						camHUD.flash(FlxColor.WHITE, 0.35);
					case 1151:
						defaultCamZoom = 1;
					case 1216:
						defaultCamZoom = 0.75;
						camHUD.flash(FlxColor.WHITE, 0.35);
				}
			}

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'nogf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && dad.curCharacter != 'nogf')
				dad.dance();
		}

		wiggleShit.update(Conductor.crochet);

		// imagine stealing MILF's zooms code, couldn't be you, AlexShadow.
		// also yeah, this controls mid-song zooms, like in MILF
		if (curSong.toLowerCase() == 'on-the-hunt' && curBeat >= 64 && curBeat < 96 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'on-the-hunt' && curBeat >= 160 && curBeat < 192 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}		

		if (curSong.toLowerCase() == 'intruders' && curBeat >= 192 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'metal-escape' && curBeat >= 48 && curBeat < 80 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}		

		if (curSong.toLowerCase() == 'metal-escape' && curBeat >= 115 && curBeat < 144 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 31 && curBeat < 127 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 159 && curBeat < 191 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'change' && curBeat >= 223 && curBeat < 271 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'sneaky' && curBeat >= 32 && curBeat < 94 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'sneaky' && curBeat >= 128 && curBeat < 190 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 72 && curBeat < 112 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 144 && curBeat < 176 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 248 && curBeat < 288 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'run-away' && curBeat >= 320 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 32 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 80 && curBeat < 96 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 128 && curBeat < 160 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 192 && curBeat < 224 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curSong.toLowerCase() == 'promenade' && curBeat >= 240 && curBeat < 256 && camZooming && FlxG.camera.zoom < 1.35 && FlxG.save.data.distractions)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.020;
			camHUD.zoom += 0.04;
		}

		if (curStage.startsWith('alleys') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			doggyOfficer.animation.play('idle'); // doggy is so hot in his officer outfi- i mean, y-you.. saw nothing
		}	

		if (curStage.startsWith('store') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			ponyStore.animation.play('idle'); // couple shit (this is gonna be so sad in refinery omg)
			zizzyStore.animation.play('idle'); // couple shit (this is gonna be so sad in refinery omg)
		}				

		if (curStage.startsWith('refinery') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			ponyRefinery.animation.play('idle'); // he do be saving his gf /j
		}

		if (curStage.startsWith('sewers') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			zeeSewers.animation.play('idle'); // they have no sister now
			zuzySewers.animation.play('idle'); // :(
		}

		if (curStage.startsWith('ship') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			willowBg.animation.play('idle'); // the lesbian bitch
		}

		if (curStage.startsWith('docks') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			ponyDocks.animation.play('idle');
		}

		if (curStage.startsWith('temple') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			robbyTemple.animation.play('idle');
		}

		if (curStage.startsWith('camp') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			ponyCamp.animation.play('idle');
			willowCamp.animation.play('idle');
		}

		if (curStage.startsWith('cabin') && curBeat % 2 == 0 && FlxG.save.data.distractions)
		{
			zeeHoliday.animation.play('idle');
			mimiHoliday.animation.play('idle');
			giraffyHoliday.animation.play('idle');
			ponyHoliday.animation.play('idle');
		}

		// idk, i dont wanna use the same code for the christmas tree cuz uhh, like i said.. idk.
		if (SONG.song.toLowerCase() == 'promenade' && curBeat % 1 == 0)
		{
			christmasTree.animation.play('idle');
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		// mid-song event my beloved
		if (curSong.toLowerCase() == 'on-the-hunt' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64 | 160:
						defaultCamZoom = 0.80;
					case 96 | 192:
						defaultCamZoom = 0.75;
				}
			}

		if (curSong.toLowerCase() == 'in-stock' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 0:
						camHUD.visible = false;
					case 28:
						defaultCamZoom = 0.95;							
					case 32:
						camHUD.visible = true;
						defaultCamZoom = 0.75;
					case 64 | 160:
						defaultCamZoom = 0.9;
					case 96 | 192:
						defaultCamZoom = 0.75;
					case 248:
						blackScreenAppear();
						camHUD.visible = false;
						camZooming = false;
				}
			}

		// i like the events i made for this one
		if (curSong.toLowerCase() == 'intruders' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 0:
						camHUD.visible = false;
					case 28:
						defaultCamZoom = 0.95;
					case 32:
						camHUD.visible = true;
						defaultCamZoom = 0.75;
					case 256:
						defaultCamZoom = 0.95;
					case 264:
						FlxTween.tween(camHUD, {alpha: 0}, 1.3);
					case 268:
						FlxG.camera.fade(FlxColor.BLACK, 1, false);
					case 272:
						camZooming = false; 
				}
			}	

		if (curSong.toLowerCase() == 'metal-escape' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 176:
						FlxG.camera.fade(FlxColor.BLACK, .3, false);
						camHUD.visible = false;
						camZooming = false;
				}
			}		

		if (curSong.toLowerCase() == 'underground' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64 | 176:
						defaultCamZoom = 1.05;
						FlxTween.tween(vignette, {alpha: 0.9}, 0.4);
					case 80 | 192:
						defaultCamZoom = 0.75;
						FlxTween.tween(vignette, {alpha: 0}, 0.4);
					case 256:
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
						FlxTween.tween(camHUD, {alpha: 0}, 0.1);
						camZooming = false;
				}
			}				

		if (curSong.toLowerCase() == 'change' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 64 | 159:
						defaultCamZoom = 0.95;
					case 95 | 223:
					    defaultCamZoom = 0.75;
					case 191:
						defaultCamZoom = 1.05;
					case 271:
						FlxTween.tween(camHUD, {alpha: 0}, 2.2);
					case 287:
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
				}
			}	

			if (curSong.toLowerCase() == 'deep-sea' && FlxG.save.data.distractions)
				{
					switch (curBeat)
					{
						case 63:
							defaultCamZoom = 1.10;
							FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);
							camGame.shake(0.004, 14);
						case 96:
							defaultCamZoom = 0.75;
							FlxTween.tween(vignetteRed, {alpha: 0}, 0.1);
						case 126:
							defaultCamZoom = 1.10;
							blackScreenAppear();
						case 128:
							blackScreenRemove();
							FlxTween.tween(vignetteRed, {alpha: 1}, 0.1);
							camGame.shake(0.004, 14);
						case 184:
							FlxTween.tween(vignetteRed, {alpha: 0}, 2);
						case 192:
							FlxG.camera.fade(FlxColor.BLACK, .1, false);
					}			
				}

			if (curSong.toLowerCase() == 'all-aboard' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 16 | 96:
						defaultCamZoom = 1.05;
					case 32 | 112:
						defaultCamZoom = 0.9;
					case 40 | 120:
						defaultCamZoom = 1.10;
					case 47 | 128:
						defaultCamZoom = 0.75;
					case 176:
						FlxTween.tween(camHUD, {alpha: 0}, 2);
						camZooming = false;
					case 192:
						FlxG.camera.fade(FlxColor.BLACK, .1, false);
				}		
			}

		    if (curSong.toLowerCase() == 'promenade' && FlxG.save.data.distractions)
			{
				switch (curBeat)
				{
					case 32:
						promenadeOverlay.visible = true;
						camHUD.flash(FlxColor.WHITE, 0.35);
				}		
			}	

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
	}

	// mid-song events functions below here hadgyuasdgjyuasdasd

	function blackScreenAppear() // im scared of the darkness :(
	{		
		dad.visible = false;
		boyfriend.visible = false;

		camHUD.visible = false;

		blackScreen2.visible = true;
	}

	function blackScreenRemove() // oh, everything's back nvm lmfaoo
	{			
		dad.visible = true;
		boyfriend.visible = true;

		camHUD.visible = true;

		blackScreen2.visible = false;
	}

	var curLight:Int = 0;
}
