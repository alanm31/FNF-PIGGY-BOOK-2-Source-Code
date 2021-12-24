package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'nogf':
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

				trace("GF Won't get Added Sucessfully :(");	

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/Player_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck

				trace("Player Added Sucessfully.");	

			case 'bfstore': // same character with no animations changes, but the guy is more darker cuz store bg shading
				var tex = Paths.getSparrowAtlas('characters/PlayerSTORE_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x2
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x2
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x2
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x2
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck x2

				trace("Player (Store Ver.) Added Sucessfully.");	

			case 'bfrefinery': // same character with no animations changes, but the guy is more darker cuz refinery bg shading x2
				var tex = Paths.getSparrowAtlas('characters/PlayerREFINERY_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x3
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x3
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x3
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x3
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck x3

				trace("Player (Refinery Ver.) Added Sucessfully.");	

			case 'bfship': // same character with no animations changes, but the guy is more darker cuz ship bg shading x3
				var tex = Paths.getSparrowAtlas('characters/PlayerSHIP_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x4
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x4
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x4
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x4
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck x4

				trace("Player (Ship Ver.) Added Sucessfully.");	

			case 'bfdocks': // same character with no animations changes, but the guy is more darker cuz docks bg shading x4
				var tex = Paths.getSparrowAtlas('characters/PlayerDOCKS_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x5
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x5
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x5
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x5
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck x5

				trace("Player (Docks Ver.) Added Sucessfully.");	

			case 'bfcamp': // same character with no animations changes, but the guy is more darker cuz camp bg shading x5
				var tex = Paths.getSparrowAtlas('characters/PlayerCAMP_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Right0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x6
				animation.addByPrefix('singRIGHT', 'Player Left0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x6
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Right Miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x6
				animation.addByPrefix('singRIGHTmiss', 'Player Left Miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x6
				animation.addByPrefix('singDOWNmiss', 'Player Down Miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle', -5);
				addOffset("singUP", 19, 5);
				addOffset("singRIGHT", 9, -10);
				addOffset("singLEFT", -16, -6);
				addOffset("singDOWN", 94, -89);
				addOffset("singUPmiss", 19, 5);
				addOffset("singRIGHTmiss", 9, -10);
				addOffset("singLEFTmiss", -16, -6);
				addOffset("singDOWNmiss", 94, -89);
				addOffset('firstDeath', -8, 90);
				addOffset('deathLoop', 29, -5);
				addOffset('deathConfirm', -23, -8);
 
				playAnim('idle');

				flipX = true; // you fucking suck x6

				trace("Player (Camp Ver.) Added Sucessfully.");	

			case 'bfperspective': // same character with no animations changes, but the guy is in another perspective
				var tex = Paths.getSparrowAtlas('characters/PlayerPERSPECTIVE_assets', 'shared');
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'Player Idle', 24, false);
				animation.addByPrefix('singUP', 'Player Up0', 24, false);
				animation.addByPrefix('singLEFT', 'Player Left0', 24, false); // HERE IS RIGHT ANIMATION CUZ FLIPX SUCKS x7
				animation.addByPrefix('singRIGHT', 'Player Right0', 24, false); // HERE IS LEFT ANIMATION CUZ FLIPX SUCKS x7
				animation.addByPrefix('singDOWN', 'Player Down0', 24, false);
				animation.addByPrefix('singUPmiss', 'Player Up miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Player Left miss', 24, false); // HERE IS RIGHT MISS ANIMATION CUZ FLIPX SUCKS x7
				animation.addByPrefix('singRIGHTmiss', 'Player Right miss', 24, false); // HERE IS LEFT MISS ANIMATION CUZ FLIPX SUCKS x7
				animation.addByPrefix('singDOWNmiss', 'Player Down miss', 24, false);

				animation.addByPrefix('firstDeath', "Player Dies", 24, false);
				animation.addByPrefix('deathLoop', "Player Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "Player Dead Confirm", 24, false);

				addOffset('idle'); // deleting the -5 in this one cuz it ruins the poses anims view
				addOffset("singUP", -4, 18);
				addOffset("singRIGHT", 25, 1);
				addOffset("singLEFT", -8, -40);
				addOffset("singDOWN", 46, -40);
				addOffset("singUPmiss", -7, 18);
				addOffset("singRIGHTmiss", 23, 0);
				addOffset("singLEFTmiss", -10, -40);
				addOffset("singDOWNmiss", 47, -42);
				addOffset('firstDeath', -84, 304);
				addOffset('deathLoop', -47, 208);
				addOffset('deathConfirm', -99, 208);
 
				playAnim('idle');

				flipX = true; // you fucking suck x7

				trace("Player (Different Perspective Ver.) Added Sucessfully.");	

			case 'rash':
				tex = Paths.getSparrowAtlas('characters/Rash_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Rash Idle', 24);
				animation.addByPrefix('singUP', 'Rash Up', 24);
				animation.addByPrefix('singRIGHT', 'Rash Right', 24);
				animation.addByPrefix('singDOWN', 'Rash Down', 24);
				animation.addByPrefix('singLEFT', 'Rash Left', 24);

				addOffset('idle');
				addOffset("singUP", -5, -8);
				addOffset("singRIGHT", 5, -66);
				addOffset("singLEFT", 116, -72);
				addOffset("singDOWN", 11, -22);

				playAnim('idle');		
				
				trace("Rash Added Sucessfully.");
					
			case 'dessa':
				tex = Paths.getSparrowAtlas('characters/Dessa_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dessa Idle', 24);
				animation.addByPrefix('singUP', 'Dessa Up', 24);
				animation.addByPrefix('singRIGHT', 'Dessa Right', 24);
				animation.addByPrefix('singDOWN', 'Dessa Down', 24);
				animation.addByPrefix('singLEFT', 'Dessa Left', 24);

				addOffset('idle');
				addOffset("singUP", -84, 92);
				addOffset("singRIGHT", 110, -45);
				addOffset("singLEFT", 167, -51);
				addOffset("singDOWN", -102, -162);

				playAnim('idle');		
				
				trace("Dessa Added Sucessfully.");	

			case 'tigry':
				tex = Paths.getSparrowAtlas('characters/Tigry_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tigry Idle', 24);
				animation.addByPrefix('singUP', 'Tigry Up', 24);
				animation.addByPrefix('singRIGHT', 'Tigry Right', 24);
				animation.addByPrefix('singDOWN', 'Tigry Down', 24);
				animation.addByPrefix('singLEFT', 'Tigry Left', 24);

				addOffset('idle');
				addOffset("singUP", -13, 5);
				addOffset("singRIGHT", -20, -14);
				addOffset("singLEFT", -8, -23);
				addOffset("singDOWN", -18, -17);

				playAnim('idle');	
				
				trace("Tigry Added Sucessfully.");	

			case 'raze':
				tex = Paths.getSparrowAtlas('characters/Raze_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Raze Idle', 24);
				animation.addByPrefix('singUP', 'Raze Up', 24);
				animation.addByPrefix('singRIGHT', 'Raze Right', 24);
				animation.addByPrefix('singDOWN', 'Raze Down', 24);
				animation.addByPrefix('singLEFT', 'Raze Left', 24);

				addOffset('idle');
				addOffset("singUP", 18, 15);
				addOffset("singRIGHT", -6, -5);
				addOffset("singLEFT", 84, -1);
				addOffset("singDOWN", 47, -68);

				playAnim('idle');	

				trace("Raze Added Sucessfully.");	
			
			case 'alfis':
				tex = Paths.getSparrowAtlas('characters/Alfis_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Alfis Idle', 24);
				animation.addByPrefix('singUP', 'Alfis Up', 24);
				animation.addByPrefix('singRIGHT', 'Alfis Right', 24);
				animation.addByPrefix('singDOWN', 'Alfis Down', 24);
				animation.addByPrefix('singLEFT', 'Alfis Left', 24);

				addOffset('idle');
				addOffset("singUP", 3, -28);
				addOffset("singRIGHT", -6, -39);
				addOffset("singLEFT", 141, -128);
				addOffset("singDOWN", 6, -176);

				playAnim('idle');	

				trace("Alfis Added Sucessfully.");	
				
			case 'willow': // the lesbian bitch
				tex = Paths.getSparrowAtlas('characters/Willow_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Willow Idle', 24);
				animation.addByPrefix('singUP', 'Willow Up', 24);
				animation.addByPrefix('singRIGHT', 'Willow Right', 24);
				animation.addByPrefix('singDOWN', 'Willow Down', 24);
				animation.addByPrefix('singLEFT', 'Willow Left', 24);

				addOffset('idle');
				addOffset("singUP", 69, 9); // sussy number
				addOffset("singRIGHT", -55, 6);
				addOffset("singLEFT", 116, -12);
				addOffset("singDOWN", -10, -240);

				playAnim('idle');	

				trace("Willow Added Sucessfully.");	

			case 'dakoda':
				tex = Paths.getSparrowAtlas('characters/Dakoda_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dakoda Idle', 24);
				animation.addByPrefix('singUP', 'Dakoda Up', 24);
				animation.addByPrefix('singRIGHT', 'Dakoda Right', 24);
				animation.addByPrefix('singDOWN', 'Dakoda Down', 24);
				animation.addByPrefix('singLEFT', 'Dakoda Left', 24);

				addOffset('idle');
				addOffset("singUP", 0, 74);
				addOffset("singRIGHT", -17, 1);
				addOffset("singLEFT", 127, -34);
				addOffset("singDOWN", 38, -80);

				playAnim('idle');	

				trace("Dakoda Added Sucessfully.");		

			case 'archie':
				tex = Paths.getSparrowAtlas('characters/Archie_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Archie Idle', 24);
				animation.addByPrefix('singUP', 'Archie Up', 24);
				animation.addByPrefix('singRIGHT', 'Archie Right', 24);
				animation.addByPrefix('singDOWN', 'Archie Down', 24);
				animation.addByPrefix('singLEFT', 'Archie Left', 24);

				addOffset('idle');
				addOffset("singUP", 0, 19);
				addOffset("singRIGHT", 0, -22);
				addOffset("singLEFT", 19, -61);
				addOffset("singDOWN", 8, -124);

				playAnim('idle');	

				trace("Archie Added Sucessfully.");		
				
			case 'markus':
				tex = Paths.getSparrowAtlas('characters/Markus_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Markus Idle', 24);
				animation.addByPrefix('singUP', 'Markus Up', 24);
				animation.addByPrefix('singRIGHT', 'Markus Right', 24);
				animation.addByPrefix('singDOWN', 'Markus Down', 24);
				animation.addByPrefix('singLEFT', 'Markus Left', 24);

				addOffset('idle');
				addOffset("singUP", -42, 9);
				addOffset("singRIGHT", -37, -46);
				addOffset("singLEFT", 78, 0);
				addOffset("singDOWN", -6, -22);

				playAnim('idle');	

				trace("Markus Added Sucessfully.");	

			case 'spidella':
				tex = Paths.getSparrowAtlas('characters/Spidella_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Spidella Idle', 24);
				animation.addByPrefix('singUP', 'Spidella Up', 24);
				animation.addByPrefix('singRIGHT', 'Spidella Right', 24);
				animation.addByPrefix('singDOWN', 'Spidella Down', 24);
				animation.addByPrefix('singLEFT', 'Spidella Left', 24);

				addOffset('idle');
				addOffset("singUP", -5, 17);
				addOffset("singRIGHT", -1, 0);
				addOffset("singLEFT", 110, -33);
				addOffset("singDOWN", -6, -71);

				playAnim('idle');	

				trace("Spidella Added Sucessfully.");	

			case 'delta':
				tex = Paths.getSparrowAtlas('characters/Delta_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Delta Idle', 24);
				animation.addByPrefix('singUP', 'Delta Up', 24);
				animation.addByPrefix('singRIGHT', 'Delta Right', 24);
				animation.addByPrefix('singDOWN', 'Delta Down', 24);
				animation.addByPrefix('singLEFT', 'Delta Left', 24);

				addOffset('idle');
				addOffset("singUP", -31, 6);
				addOffset("singRIGHT", -26, -6);
				addOffset("singLEFT", 82, -30);
				addOffset("singDOWN", -29, -184);

				playAnim('idle');	

				trace("Delta Added Sucessfully.");

			case 'penny':
				tex = Paths.getSparrowAtlas('characters/Penny_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Penny Idle', 24);
				animation.addByPrefix('singUP', 'Penny Up', 24);
				animation.addByPrefix('singRIGHT', 'Penny Right', 24);
				animation.addByPrefix('singDOWN', 'Penny Down', 24);
				animation.addByPrefix('singLEFT', 'Penny Left', 24);

				addOffset('idle');
				addOffset("singUP", -35, 97);
				addOffset("singRIGHT", -49, -42);
				addOffset("singLEFT", 58, -18);
				addOffset("singDOWN", -108, -202);

				playAnim('idle');	

				trace("Penny Added Sucessfully.");	
		}

		dance();

		if (isPlayer) // nm (or kade) what the fuck u did here, this is the reason why are player animations bugged without the flipX & the 0 in his normal animations
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'nogf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'nogf': // OMFG I FORGOT TO SET THIS TO NOGF TOO. THIS IS WHY IT WAS GIVING ME NULL OBJECT REFERENCE ERROR ON DEBUG 
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'nogf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
