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
				
			case 'raze':
				tex = Paths.getSparrowAtlas('characters/Raze_assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Raze Idle', 24);
				animation.addByPrefix('singUP', 'Raze Up', 24);
				animation.addByPrefix('singRIGHT', 'Raze Right', 24);
				animation.addByPrefix('singDOWN', 'Raze Down', 24);
				animation.addByPrefix('singLEFT', 'Raze Left', 24);

				addOffset('idle');
				addOffset("singUP", -13, 5);
				addOffset("singRIGHT", -20, -14);
				addOffset("singLEFT", -8, -23);
				addOffset("singDOWN", -18, -17);

				playAnim('idle');								
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
			case 'gf':
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
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
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

		if (curCharacter == 'gf')
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
